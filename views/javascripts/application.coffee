# application.coffee

# to do : enum
pages = ['landing','about','work','gear','blog','contact']
page = 0

$(document).ready ->
  navTop = $('#'+pages[1]).position().top - 80
  $('#navigation-bar').css({'top':navTop, 'bottom':'auto'})

  $('#landing').parent().bind 'DOMMouseScroll mousewheel', ->

    currentPos = $(this).scrollTop()
    currentNavPos = $('#navigation-bar').position().top
    scrollDown = event.wheelDelta < 0

    if(currentNavPos > 0 && scrollDown)
      if(!$('#navigation-bar').is(':animated'))
          $('#navigation-bar').animate({'top': 0})

    else if(currentPos == 0 && !scrollDown && currentNavPos < navTop)
      if(!$('#navigation-bar').is(':animated'))
          $('#navigation-bar').animate({'top': navTop})

    if(currentNavPos > 0)
      return false

    # top button handlers
    for cur_page in pages
      if($('#'+cur_page).offset().top < 100 && $('#'+cur_page).offset().top > -$('#'+cur_page).height() && !$("#"+cur_page+"_button").is(':animated'))
        $("#"+cur_page+"_button").addClass('current')
        $("#"+cur_page+"_button").removeClass('not_current')
      else
        $("#"+cur_page+"_button").removeClass('current')
        $("#"+cur_page+"_button").addClass('not_current')


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
