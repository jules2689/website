//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.remotipart
//= require bootstrap-sprockets
//= require jquery.datetimepicker
//= require turbolinks
//= require pagedown_bootstrap
//= require pagedown_init
//= require masonry
//= require_tree .

$(document).on("page:change", function(){
  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
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
