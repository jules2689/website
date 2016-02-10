//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ahoy

// Form Specific
//= require pagedown_bootstrap
//= require pagedown_init
//= require jquery.remotipart
//= require jquery.datetimepicker
//= require highlight.pack
//= require galleria

// Tags
//= require taggle
//= require jquery.autocomplete

// Bootstrap
//= require bootstrap/dropdown
//= require bootstrap/alert
//= require bootstrap/modal
//= require bootstrap/collapse

//= require_tree .

$(document).on("page:change", function(){

  ahoy.trackView();

  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
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
});
