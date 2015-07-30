# application.coffee
pages = ['landing','about','work','gear','blog','contact']
page = 0

$(document).ready ->
  $('#navigation-bar').css({'top':$(window).height(), 'bottom':'auto'})


  # to do : enum

  $('#landing').parent().bind 'DOMMouseScroll mousewheel', ->

    if $('.content-pane').is(':animated')
      return

    if(event.wheelDelta < 0)
      scrollDown()
    else
      scrollUp()

scrollDown = ->

  if page == pages.length - 1
    return
  else if page == 0
    $('#navigation-bar').animate({'top': 0}, 1000)

  $('.content-pane').animate {scrollTop : $('.content-pane').scrollTop() + $('#'+pages[page]).height()},1000, ->
    page++


scrollUp = ->

  if page == 0
    return
  else if page == 1
    $('#navigation-bar').animate({'top': $(window).height()}, 1000)

  $('.content-pane').animate {scrollTop : $('.content-pane').scrollTop() - $('#'+pages[page]).height()},1000, ->
    page--
