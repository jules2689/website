import 'highlight.js/styles/github.css';

import hljs from 'highlight.js/lib/core';
import ruby from 'highlight.js/lib/languages/ruby';
import yaml from 'highlight.js/lib/languages/yaml';
import shell from 'highlight.js/lib/languages/shell';
import bash from 'highlight.js/lib/languages/bash';
import nginx from 'highlight.js/lib/languages/nginx';
import javascript from 'highlight.js/lib/languages/javascript';
import json from 'highlight.js/lib/languages/json';
import dockerfile from 'highlight.js/lib/languages/dockerfile';
import ini from 'highlight.js/lib/languages/ini';
import { highlightCaddyCodeBlocks, isCaddyFence } from './caddyfile-highlight';
import Panzoom from '@panzoom/panzoom';

hljs.registerLanguage('ruby', ruby);
hljs.registerLanguage('yaml', yaml);
hljs.registerLanguage('shell', shell);
hljs.registerLanguage('bash', bash);
hljs.registerLanguage('sh', bash);
hljs.registerLanguage('zsh', bash);
hljs.registerLanguage('nginx', nginx);
hljs.registerLanguage('javascript', javascript);
hljs.registerLanguage('js', javascript);
hljs.registerLanguage('json', json);
hljs.registerLanguage('dockerfile', dockerfile);
hljs.registerLanguage('ini', ini);

/** Dark-mode prose image mat before / when edge sample matches (see applyProseImageMatFromEdges) */
const IMG_MAT_DEFAULT_DARK = 'rgb(18, 18, 18)';

let markdownImgZoomEscapeHandler = null;
let markdownImgZoomLastFocus = null;

function cleanupMarkdownLightboxPanzoom(overlay) {
  if (!overlay) return;
  const inner = overlay.querySelector('.markdown-img-lightbox__inner');
  const fullImg = inner?.querySelector('img');
  if (fullImg && fullImg._markdownPanzoomOnLoad) {
    fullImg.onload = null;
    fullImg._markdownPanzoomOnLoad = null;
  }
  if (overlay._markdownWheelHandler && inner) {
    inner.removeEventListener('wheel', overlay._markdownWheelHandler);
    overlay._markdownWheelHandler = null;
  }
  if (overlay._panzoom) {
    try {
      overlay._panzoom.reset({ animate: false });
    } catch (_) {
      /* ignore */
    }
    overlay._panzoom.destroy();
    overlay._panzoom = null;
  }
}

function closeMarkdownImageLightbox() {
  const overlay = document.getElementById('markdown-img-lightbox');
  if (!overlay || !overlay.classList.contains('is-open')) return;
  cleanupMarkdownLightboxPanzoom(overlay);
  overlay.classList.remove('is-open');
  document.body.style.overflow = '';
  if (markdownImgZoomEscapeHandler) {
    document.removeEventListener('keydown', markdownImgZoomEscapeHandler);
    markdownImgZoomEscapeHandler = null;
  }
  if (markdownImgZoomLastFocus && typeof markdownImgZoomLastFocus.focus === 'function') {
    markdownImgZoomLastFocus.focus();
  }
  markdownImgZoomLastFocus = null;
}

function bindPanzoomToLightbox(overlay) {
  const inner = overlay.querySelector('.markdown-img-lightbox__inner');
  const fullImg = inner?.querySelector('img');
  if (!inner || !fullImg) return;

  cleanupMarkdownLightboxPanzoom(overlay);

  const start = () => {
    overlay._panzoom = Panzoom(fullImg, {
      maxScale: 15,
      minScale: 1,
      panOnlyWhenZoomed: true,
      animate: false,
      cursor: 'grab',
      step: 0.55,
    });
    overlay._markdownWheelHandler = (e) => overlay._panzoom.zoomWithWheel(e);
    inner.addEventListener('wheel', overlay._markdownWheelHandler, { passive: false });
  };

  if (fullImg.complete && fullImg.naturalWidth) {
    requestAnimationFrame(start);
  } else {
    fullImg._markdownPanzoomOnLoad = true;
    fullImg.onload = () => {
      fullImg.onload = null;
      fullImg._markdownPanzoomOnLoad = null;
      requestAnimationFrame(start);
    };
  }
}

function openMarkdownImageLightbox(sourceImg) {
  let overlay = document.getElementById('markdown-img-lightbox');
  if (!overlay) {
    overlay = document.createElement('div');
    overlay.id = 'markdown-img-lightbox';
    overlay.className = 'markdown-img-lightbox';
    overlay.setAttribute('role', 'dialog');
    overlay.setAttribute('aria-modal', 'true');
    overlay.setAttribute('aria-label', 'Image preview — scroll to zoom, drag to pan when zoomed');
    overlay.innerHTML =
      '<button type="button" class="markdown-img-lightbox__close panzoom-exclude" aria-label="Close">&times;</button>' +
      '<p class="markdown-img-lightbox__hint">Scroll to zoom · drag to pan</p>' +
      '<div class="markdown-img-lightbox__inner"><img src="" alt="" /></div>';
    document.body.appendChild(overlay);
    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) closeMarkdownImageLightbox();
    });
    const closeBtn = overlay.querySelector('.markdown-img-lightbox__close');
    closeBtn.addEventListener('click', () => closeMarkdownImageLightbox());
  }
  const fullImg = overlay.querySelector('.markdown-img-lightbox__inner img');
  fullImg.src = sourceImg.currentSrc || sourceImg.src;
  fullImg.alt = sourceImg.alt || '';
  markdownImgZoomLastFocus = document.activeElement;
  overlay.classList.add('is-open');
  document.body.style.overflow = 'hidden';
  markdownImgZoomEscapeHandler = (e) => {
    if (e.key === 'Escape') closeMarkdownImageLightbox();
  };
  document.addEventListener('keydown', markdownImgZoomEscapeHandler);
  bindPanzoomToLightbox(overlay);
  const closeBtn = overlay.querySelector('.markdown-img-lightbox__close');
  if (closeBtn) closeBtn.focus();
}

const EDGE_QUANT_SHIFT = 3; /* bucket quantized RGB for mode; colour from mean inside winning bucket */

function edgeQuantKey(r, g, b) {
  return (r >> EDGE_QUANT_SHIFT) | ((g >> EDGE_QUANT_SHIFT) << 5) | ((b >> EDGE_QUANT_SHIFT) << 10);
}

/**
 * Most common quantized colour on the outermost pixel ring only (not mean/median of whole edge).
 * Mean is taken only among pixels in the winning bucket so the mat matches the frame, not bucket centre.
 * imageSmoothingEnabled=false avoids resize blending charcoal into black.
 */
function sampleImageEdgeMode(img) {
  const natW = img.naturalWidth;
  const natH = img.naturalHeight;
  if (!natW || !natH) return null;

  const maxDim = 480;
  const scale = Math.min(1, maxDim / Math.max(natW, natH));
  const cw = Math.max(1, Math.round(natW * scale));
  const ch = Math.max(1, Math.round(natH * scale));

  const canvas = document.createElement('canvas');
  canvas.width = cw;
  canvas.height = ch;
  const ctx = canvas.getContext('2d');
  if (!ctx) return null;

  ctx.imageSmoothingEnabled = false;

  try {
    ctx.drawImage(img, 0, 0, cw, ch);
  } catch (_) {
    return null;
  }

  let imageData;
  try {
    imageData = ctx.getImageData(0, 0, cw, ch);
  } catch (_) {
    /* SecurityError: cross-origin without CORS */
    return null;
  }

  const d = imageData.data;
  /** @type {Map<number, { n: number, r: number, g: number, b: number }>} */
  const buckets = new Map();

  function tallyPixel(x, y) {
    const xi = Math.min(cw - 1, Math.max(0, x));
    const yi = Math.min(ch - 1, Math.max(0, y));
    const i = (yi * cw + xi) * 4;
    if (d[i + 3] < 250) return;
    const r = d[i];
    const g = d[i + 1];
    const b = d[i + 2];
    const key = edgeQuantKey(r, g, b);
    let o = buckets.get(key);
    if (!o) {
      o = { n: 0, r: 0, g: 0, b: 0 };
      buckets.set(key, o);
    }
    o.n += 1;
    o.r += r;
    o.g += g;
    o.b += b;
  }

  /* Single-pixel perimeter only — a thick band samples past the frame into diagram black */
  let x;
  let y;
  for (x = 0; x < cw; x += 1) {
    tallyPixel(x, 0);
    tallyPixel(x, ch - 1);
  }
  for (y = 1; y < ch - 1; y += 1) {
    tallyPixel(0, y);
    tallyPixel(cw - 1, y);
  }

  if (buckets.size === 0) return null;

  let bestKey = null;
  let bestN = 0;
  buckets.forEach((o, key) => {
    if (o.n > bestN) {
      bestN = o.n;
      bestKey = key;
    }
  });

  if (bestKey === null) return null;
  const w = buckets.get(bestKey);
  if (!w || w.n < 1) return null;
  return `rgb(${Math.round(w.r / w.n)}, ${Math.round(w.g / w.n)}, ${Math.round(w.b / w.n)})`;
}

function applyProseImageMatFromEdges(img) {
  const dark = document.documentElement.classList.contains('dark');
  if (dark) {
    img.style.backgroundColor = IMG_MAT_DEFAULT_DARK;
  } else {
    img.style.backgroundColor = '';
  }

  const rgb = sampleImageEdgeMode(img);
  if (!rgb) return;
  if (dark && rgb === IMG_MAT_DEFAULT_DARK) return;
  img.style.backgroundColor = rgb;
}

function initProseImageMatFromEdges() {
  const roots = document.querySelectorAll(
    '.article-body, .page-content:not(.blog) .wrapper:not(.article-body)'
  );
  const dark = document.documentElement.classList.contains('dark');
  roots.forEach((root) => {
    root.querySelectorAll('img').forEach((img) => {
      if (img.closest('pre')) return;
      if (img.complete && img.naturalWidth) {
        applyProseImageMatFromEdges(img);
      } else {
        if (dark) {
          img.style.backgroundColor = IMG_MAT_DEFAULT_DARK;
        } else {
          img.style.backgroundColor = '';
        }
        img.addEventListener('load', () => applyProseImageMatFromEdges(img), { once: true });
      }
    });
  });

  const reapplyMatsOnThemeChange = () => {
    const isDark = document.documentElement.classList.contains('dark');
    roots.forEach((root) => {
      root.querySelectorAll('img').forEach((img) => {
        if (img.closest('pre')) return;
        if (img.complete && img.naturalWidth) {
          applyProseImageMatFromEdges(img);
        } else if (isDark) {
          img.style.backgroundColor = IMG_MAT_DEFAULT_DARK;
        } else {
          img.style.backgroundColor = '';
        }
      });
    });
  };
  new MutationObserver(reapplyMatsOnThemeChange).observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['class'],
  });
}

function initMarkdownImageZoom() {
  const roots = document.querySelectorAll(
    '.article-body, .page-content:not(.blog) .wrapper:not(.article-body)'
  );
  roots.forEach((root) => {
    root.querySelectorAll('img').forEach((img) => {
      if (img.closest('a')) return;
      if (img.closest('pre')) return;
      if (img.classList.contains('markdown-img-zoom--bound')) return;
      img.classList.add('markdown-img-zoom--bound');
      img.tabIndex = 0;
      img.setAttribute('role', 'button');
      const label = img.alt ? `View larger: ${img.alt}` : 'View larger image';
      img.setAttribute('aria-label', label);
      const open = () => openMarkdownImageLightbox(img);
      img.addEventListener('click', open);
      img.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          open();
        }
      });
    });
  });
}

document.addEventListener('DOMContentLoaded', (event) => {
  document.querySelectorAll('pre code').forEach((block) => {
    try {
      hljs.highlightBlock(block);
    } catch (_) {
      /* Unknown fence language class: fall back to auto-detection without invalid class */
      block.className = block.className.replace(/\blanguage-\S+\b/g, '').trim();
      hljs.highlightBlock(block);
    }
  });

  highlightCaddyCodeBlocks().catch((err) => {
    console.error('Caddyfile highlighting failed', err);
  });

  // Copy-to-clipboard buttons for code blocks
  document.querySelectorAll('pre code').forEach((block) => {
    const pre = block.closest('pre');
    if (!pre || pre.querySelector('.copy-code-btn')) return;
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'copy-code-btn';
    btn.textContent = 'Copy';
    btn.setAttribute('aria-label', 'Copy code');
    btn.addEventListener('click', () => {
      const text = block.textContent || '';
      navigator.clipboard.writeText(text).then(() => {
        btn.textContent = 'Copied!';
        btn.classList.add('copied');
        setTimeout(() => {
          btn.textContent = 'Copy';
          btn.classList.remove('copied');
        }, 1500);
      });
    });
    pre.insertBefore(btn, pre.firstChild);
  });

  document.querySelectorAll('.tab').forEach((tab) => {
    tab.addEventListener('click', function() {
    document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'))
      document.querySelectorAll('.tab').forEach(el => el.classList.remove('active'))

      const tabContent = document.querySelector(this.getAttribute('data-href'))
      if (tabContent) tabContent.classList.add('active')
      this.classList.add('active')
    })
  })

  /// DARK MODE

  var theme = localStorage.getItem('theme')
  var userPrefersDark = window.matchMedia('(prefers-color-scheme: dark)')
  var toggleDark = document.querySelectorAll('#toggle-dark')
  var toggleLight = document.querySelectorAll('#toggle-light')
  var htmlElem = document.querySelector('html')

  if (theme === 'dark' || (!theme && userPrefersDark.matches)) {
    htmlElem.classList.add('dark')
    toggleDark.forEach(el => el.classList.add('visible'))
    toggleLight.forEach(el => el.classList.remove('hidden'))
  } else {
    toggleLight.forEach(el => el.classList.add('visible'))
    toggleDark.forEach(el => el.classList.remove('hidden'))
  }

  toggleLight.forEach(el => {
    el.addEventListener('click', function () {
      localStorage.setItem('theme', 'light')
      htmlElem.classList.remove('dark')
      toggleDark.forEach(el => el.classList.add('visible'))
      toggleDark.forEach(el => el.classList.remove('hidden'))
      toggleLight.forEach(el => el.classList.add('hidden'))
      toggleLight.forEach(el => el.classList.remove('visible'))
      highlightCaddyCodeBlocks().catch(() => {})
    })
  })

  toggleDark.forEach(el => {
    el.addEventListener('click', function () {
      localStorage.setItem('theme', 'dark')
      htmlElem.classList.add('dark')
      toggleLight.forEach(el => el.classList.add('visible'))
      toggleLight.forEach(el => el.classList.remove('hidden'))
      toggleDark.forEach(el => el.classList.add('hidden'))
      toggleDark.forEach(el => el.classList.remove('visible'))
      highlightCaddyCodeBlocks().catch(() => {})
    })
  })

  initProseImageMatFromEdges();
  initMarkdownImageZoom();
});
