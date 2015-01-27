//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
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