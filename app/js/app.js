$(document).on( "ready page:change", function(){
  var container = document.querySelector('.card-container');
  var msnry = new Masonry( container, {
    itemSelector: '.card'
  });

  $(".card a").hover(
    function() {
      $( this ).find("h2").addClass( "hover" );
    }, function() {
      $( this ).find("h2").removeClass( "hover" );
    }
  );

});
