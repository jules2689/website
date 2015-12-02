//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.remotipart
//= require bootstrap-sprockets
//= require jquery.datetimepicker
//= require turbolinks
//= require pagedown_bootstrap
//= require pagedown_init
//= require stackblur
//= require cards
//= require galleria
//= require masonry
//= require highlight.pack
//= require_tree .

$(document).on("page:change", function(){
  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });

  $('pre').each(function(i, block) {
    hljs.highlightBlock(block);
  });

  (function() {
      var pre = document.getElementsByTagName('pre'),
          pl = pre.length;
      for (var i = 0; i < pl; i++) {
          if (pre[i].innerHTML.indexOf("<code>") == -1) {
            pre[i].innerHTML = "<code>" + pre[i].innerHTML + "</code>";
          }
          pre[i].innerHTML = '<span class="line-number"></span>' + pre[i].innerHTML + '<span class="cl"></span>';
          var num = pre[i].innerHTML.split(/\n/).length - 1;
          for (var j = 0; j < num; j++) {
              var line_num = pre[i].getElementsByTagName('span')[0];
              line_num.innerHTML += '<span>' + (j + 1) + '</span>';
          }
      }
  })();

  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });

  $("#add-image").click(function(e) {
      $("div.image-div")
              .last()
              .clone()
              .appendTo($(".modal-body"))
              .find("input").val('').attr("name",function(i,oldVal) {
                  return oldVal.replace(/(.*)image_(\d+)(.*)/,function(_,a,b,c){
                      return a + "image_" + (+b + 1) + c;
                  });
              });        
          return false; 
  });

  $('.datetimepicker').datetimepicker({ format: "Y-m-d H:i +0500", validateOnBlur: false });

  $("#sortable").sortable({
    stop: function( event, ui ) {
      $("#sortable li").each(function(index){
        $(this).attr("position", index);
      });
    }
  });

  $('#save-positions').on('click', function() {
    $("#status").html("Saving Positions...");

    var positions = [];
    $('#sortable li').each(function(index){
      positions.push([$(this).attr('id'), $(this).attr('position')]);
    })

    $.post( "/front_page_widgets/positions", { "positions[]" : positions })
      .done(function( data ) {
        $("#status").html("Success!");
        window.location.href = "/";
      });
  });

});
