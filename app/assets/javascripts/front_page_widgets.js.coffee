$(document).on 'page:change', ->

  $(window).on 'resize', ->
    $('.front-card-container').masonry itemSelector: '.front-card'

  $('img').load ->
    $('.front-card-container').masonry itemSelector: '.front-card'

  $('.front-card-container').masonry itemSelector: '.front-card'
  
  $('.front-card a').hover (->
    $(this).find('h2').addClass 'hover'
  ), ->
    $(this).find('h2').removeClass 'hover'

