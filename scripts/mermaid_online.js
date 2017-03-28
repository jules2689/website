var system = require('system');
var args = system.args;

var fs = require('fs');
var graph = fs.read(args[1])

var url = "https://knsv.github.io/mermaid/live_editor/#/edit/" + this.btoa(graph);
var page = require('webpage').create();
 
page.viewportSize = { width: 1920, height: 1080 };
page.open(url, function start(status) {
  window.setTimeout(function () {
    var ua = page.evaluate(function() {
      var divs = document.getElementsByTagName('div');
      for (var j = 0; j < divs.length; j++) {
        divs[j].setAttribute("xmlns", "http://www.w3.org/1999/xhtml");
      }
      return document.getElementsByClassName('mermaid')[0].innerHTML;
    });

    fs.write(args[1] + ".svg", ua, 'w');
    phantom.exit();
  }, 1000);
});