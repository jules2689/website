import 'highlight.js/styles/github.css';

import hljs from 'highlight.js/lib/core';
import ruby from 'highlight.js/lib/languages/ruby';
import yaml from 'highlight.js/lib/languages/yaml';
import shell from 'highlight.js/lib/languages/shell';

hljs.registerLanguage('ruby', ruby);
hljs.registerLanguage('yaml', yaml);
hljs.registerLanguage('shell', shell);

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
});
