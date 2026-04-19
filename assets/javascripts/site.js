import 'highlight.js/styles/github.css';

import hljs from 'highlight.js/lib/core';
import ruby from 'highlight.js/lib/languages/ruby';
import yaml from 'highlight.js/lib/languages/yaml';
import shell from 'highlight.js/lib/languages/shell';
import Panzoom from '@panzoom/panzoom';

hljs.registerLanguage('ruby', ruby);
hljs.registerLanguage('yaml', yaml);
hljs.registerLanguage('shell', shell);

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
    hljs.highlightBlock(block);
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
    })
  })

  initMarkdownImageZoom();
});
