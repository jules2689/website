$(document).on( "ready page:change", function(){

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
