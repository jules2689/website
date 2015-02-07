//= require jquery
//= require jquery_ujs
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

  $('img').load(function(){
    $(".card-container").masonry({itemSelector: '.card'});
  });
  $(".card-container").masonry({itemSelector: '.card'});

  $(".card a").hover(
    function() {
      $( this ).find("h2").addClass( "hover" );
    }, function() {
      $( this ).find("h2").removeClass( "hover" );
    }
  );
});
