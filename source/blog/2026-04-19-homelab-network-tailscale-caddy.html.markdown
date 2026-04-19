---
title: "Homelab networking: splitting clients, prod, and AI with Tailscale and Caddy"
date: 2026/04/19
description: "A realistic, isolated homelab setup that includes AI workloads"
social_image: /images/homelab.png
social_image_alt: "Diagram of homelab with Clients, Production, and AI zones, Caddy on 443 and 8443, and Docker service vs container networks"
tags:
  - Security
  - Deploys
---

I host a number of services at home on a custom-built [Ansible](https://www.ansible.com/)-backed homelab. It is set up with full TLS and restricted access using [Tailscale](https://tailscale.com/).

Historically this was straightforward: I exposed port 443 over Tailscale, pointed the A record at that host, and that let me resolve and serve the requested content from my home server.

As I have started to work more with local AI agents, such as [OpenCode](https://opencode.ai/), [llama.cpp](https://github.com/ggerganov/llama.cpp), [Whisper](https://github.com/openai/whisper), and other applications, I have grown more concerned about how much of the homelab they can reach.

This post covers how I split subnets and the measures I have taken to isolate systems and keep authentication and authorization explicit.

# The hosts

Today I have three nodes in my homelab:

1. `roc` [prod]
   - This is a [Beelink](https://www.bee-link.com/) Ser8 Ryzen 7 8845HS node with 32GB of RAM
   - This is my primary node
2. `bluejay` [prod]
   - This is a 2019 MacBook Pro (Core i9) with 32GB of RAM
   - This is my secondary node
3. `robin` [ai]
   - This is an M1 Mac mini with 16GB of RAM
   - This is an AI node. It runs [OpenCode](https://opencode.ai/) and [Whisper](https://github.com/openai/whisper).

In the future I intend to add more secondary nodes for backup purposes, and a Mac Studio for local LLM inference.

# The subnets

I split the homelab into **clients**, **prod**, and **AI** subnets in Tailscale. ACLs pin who can open which ports instead of relying on one flat LAN. For example:

- `Clients` can access the `Prod` subnet on port 443
  - On selected nodes, game ports are also allowed (for example, for [Project Zomboid](https://projectzomboid.com/))
- `Prod` can also access `Prod` on port 443
- `AI` **cannot** access port 443 on `Prod`, but can access port 8443

![Homelab network diagram showing Clients, Production (primary network), and AI (guest network), with Caddy on ports 443 and 8443 and a Docker network example](/images/homelab.png)

## Prod subnet

The production subnet holds most of my servers. Right now this includes two nodes, `roc` and `bluejay`. `roc` is my primary node and `bluejay` is a secondary node.

Each server runs different services in [Docker](https://www.docker.com/) [Compose](https://docs.docker.com/compose/) projects. Each Compose project exposes the minimal set of ports. Notably, it does not use the `ports` stanza, which would bind services to the host network; it uses `expose` instead to document container ports without publishing them to the host.

### Docker networks

On each host I use roughly a dozen user-defined [Docker](https://www.docker.com/) bridge networks.

The local [Caddy](https://caddyserver.com/) instance is attached to a set of those networks, and each project attaches one of them to its service container. That lets Caddy reach each service without being able to reach, for example, a database container on that project's internal-only network.

![Docker Compose network setup](/images/docker-setup.png)

I first tried one network per Compose project so each stack and Caddy had an isolated connection. That was easy to reason about, but Caddy paid for it at startup: more networks meant more attachments and more internal DNS to settle, and restarts took far too long.

So I moved to a smaller set of shared bridges, e.g. `monitoring_net`, `games_net`, instead of one network per project. On that kind of bridge, containers can still reach peers by container IP on any port a process is listening on.

Overall it is a workable middle ground: enough segmentation to matter in practice, without making every Caddy restart a long-running event (during which the homelab was inaccessible).

### Secondary nodes

This is more of an aside, but the question may already occur to readers: isn't the primary node a single point of failure?

Today, the primary host **is** a single point of failure. The A record points to this node exclusively, and it must be up to resolve requests, even when it only reverse-proxies to a secondary node.

In the future I would like the A record to cover secondary nodes as well. That would require Caddy changes so any node can route a request to the right host. Today, only the primary host knows how to reach services on secondaries.

Although I experimented with that approach early on, open questions remained about routing when the same service runs on multiple hosts (for example, [Backrest](https://github.com/garethgeorge/backrest) runs on all nodes for local backups).

Future work should allow me to better distribute resolution to reduce dependency on a primary node.

## AI subnet

When a host is dedicated to AI agents, I take extra precautions around access to and from that machine:

- First, the AI node is tagged in Tailscale, which blocks it from connecting to port 443 on `Prod`.
- Second, it runs on a guest network, so even if it tried, it could not reach my production hosts over the LAN.
- Third, these hosts are isolated in other ways. For example, they use a dedicated [GitHub](https://github.com/) account and, when they are Macs, a dedicated Apple ID used only for AI-agent machines.

More importantly, I run [MCP](https://modelcontextprotocol.io/) servers and other services (for example, a [Docker registry](https://hub.docker.com/_/registry)) that I want to expose selectively without granting access to everything.

I run a "Proxy" Caddy instance on the prod host, listening on port 8443, which is set up for that restricted surface: it reverse-proxies to the main Caddy on port 443 for `mcp-*` hosts and the registry. Everything else returns 404.

## Clients subnet

The client subnet is simple: it is the Tailscale nodes that are not servers. For example, my iPhone, my [Kobo](https://www.kobo.com/) e-reader, and my MacBook.

Those nodes can reach production on port 443. On selected nodes, I also allow extra ports for game servers.

# Conclusion

None of this replaces careful service configuration, but it stacks sensible defaults:

- Tailscale ACLs say which role may open which port
- guest Wi-Fi keeps untrusted AI agents off the production LAN
- and [Docker](https://www.docker.com/) networking plus Caddy keeps the published port surface small while Caddy terminates TLS for internal hops.

If you are in a similar spot and want to run local models and agents, the useful move is not “more VPN,” but **narrower paths**:

- Separate identities (GitHub accounts, Apple IDs, and so on).
- Separate networks so you are not relying on a broadly permissive LAN.
- A separate Caddy listener (for example, on 8443) that terminates only the services you mean to expose.
- Separate Tailscale subnets (or equivalent) that restrict port access to that narrower entry point.

This is not bulletproof, but it is a reasonable trade-off for the amount of infrastructure I run. I will keep iterating as I add nodes. Next up is a Mac Studio for local LLMs and, if I go further with unsupervised agents, the same minimal-access pattern as above.