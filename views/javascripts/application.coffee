# application.coffee

# to do : enum
pages = ['landing','about','work','gear','blog','contact']
page = 0

$(document).ready ->
  navTop = $('#'+pages[1]).position().top - 80
  $('#navigation-bar').css({'top':navTop, 'bottom':'auto'})

  $('#landing').parent().bind 'DOMMouseScroll mousewheel', ->


    if($('#navigation-bar').position().top > 0 && event.wheelDelta < 0)
      if(!$('#navigation-bar').is(':animated'))
          $('#navigation-bar').animate({'top': 0})

      # $('#navigation-bar').css({'top': "+=" + event.wheelDelta})

      # if($('#navigation-bar').position().top < 0)
      #   $('#navigation-bar').css({'top': 0})

    else if($(this).scrollTop() == 0 && event.wheelDelta > 0 && $('#navigation-bar').position().top < navTop)
      if(!$('#navigation-bar').is(':animated'))
          $('#navigation-bar').animate({'top': navTop})
      # $('#navigation-bar').css({'top': "+=" + event.wheelDelta})

      # if($('#navigation-bar').position().top > navTop)
      #   $('#navigation-bar').css({'top': navTop})

    if($('#navigation-bar').position().top > 0)
      return false

    # lock scrolling :

    # if $('.content-pane').is(':animated')
    #   return
    #
    # if(event.wheelDelta < 0)
    #   scrollDown()
    # else
    #   scrollUp()

scrollDown = ->

  if page == pages.length - 1
    return
  else if page == 0
    $('#navigation-bar').animate({'top': 0}, 1000)

  position = $('#'+pages[page+1]).position()

  $('.content-pane').animate {scrollTop : position.top},1000, ->
    page++

scrollUp = ->

  if page == 0
    return
  else if page == 1
    $('#navigation-bar').animate({'top':$('#'+pages[1]).position().top - 80}, 1000)

  position = $('#'+pages[page-1]).position()
  $('.content-pane').animate {scrollTop : position.top},1000, ->
    page--
