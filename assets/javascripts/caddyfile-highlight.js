/**
 * Caddyfile highlighting via Shiki + the official vscode-caddyfile TextMate grammar
 * (https://github.com/caddyserver/vscode-caddyfile, MIT).
 *
 * All Shiki imports are static so Webpack emits a single site.min.js bundle. Middleman's
 * external pipeline does not serve separate async chunk files under /javascripts/.
 */
import { createHighlighterCore } from '@shikijs/core';
import { createOnigurumaEngine } from 'shiki/engine/oniguruma';
import wasm from 'shiki/wasm';
import ghLight from '@shikijs/themes/github-light';
import dracula from '@shikijs/themes/dracula';
import grammar from '../vendor/caddyfile.tmLanguage.json';

let highlighterPromise = null;

function isDarkMode() {
  return document.documentElement.classList.contains('dark');
}

function getHighlighter() {
  if (!highlighterPromise) {
    highlighterPromise = (async () => {
      const engine = await createOnigurumaEngine(wasm);
      return createHighlighterCore({
        themes: [ghLight, dracula],
        langs: [grammar],
        engine,
      });
    })();
  }
  return highlighterPromise;
}

function isCaddyFence(block) {
  return (
    block.classList.contains('language-caddy') || block.classList.contains('language-caddyfile')
  );
}

/**
 * Highlight `language-caddy` / `language-caddyfile` blocks using Shiki (same engine as VS Code).
 * @param {ParentNode} [root]
 */
export async function highlightCaddyCodeBlocks(root = document) {
  const blocks = root.querySelectorAll('pre code.language-caddy, pre code.language-caddyfile');
  if (!blocks.length) return;

  const h = await getHighlighter();
  const theme = isDarkMode() ? 'dracula' : 'github-light';

  blocks.forEach((code) => {
    const pre = code.closest('pre');
    if (!pre) return;

    const source = code.textContent || '';
    const html = h.codeToHtml(source, { lang: 'Caddyfile', theme });

    const wrap = document.createElement('div');
    wrap.innerHTML = html.trim();
    const shikiPre = wrap.querySelector('pre');
    const shikiCode = shikiPre?.querySelector('code');
    if (!shikiPre || !shikiCode) return;

    pre.style.backgroundColor = shikiPre.style.backgroundColor;
    pre.style.color = shikiPre.style.color;
    code.innerHTML = shikiCode.innerHTML;
    code.classList.remove('hljs');
    code.classList.add('shiki-caddy');
  });
}

export { isCaddyFence };
