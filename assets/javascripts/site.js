import 'highlight.js/styles/github.css';

import hljs from 'highlight.js/lib/core';
import ruby from 'highlight.js/lib/languages/ruby';
hljs.registerLanguage('ruby', ruby);

document.addEventListener('DOMContentLoaded', (event) => {
  document.querySelectorAll('pre code').forEach((block) => {
    hljs.highlightBlock(block);
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
});
