# application.coffee

# to do : enum
pages = ['landing','about','work','gear','blog','contact']
page = 0

$(document).ready ->
  navTop = $('#'+pages[1]).position().top - 80
  # $('#navigation-bar').css {
  #   'top': navTop,
  #   'bottom': 'auto'
  # }

  $('#landing').parent().bind 'DOMMouseScroll mousewheel', (e, delta) ->

    currentPos = this.scrollTop
    currentNavPos = $('#navigation-bar').position().top

    # normalize the wheel delta
    delta = delta || -e.originalEvent.detail / 3 || e.originalEvent.wheelDelta / 120
    scrollDown = delta < 0
    scrollUp   = delta > 0

    # arrow
    if currentPos > 10
      if $('#arrow').css( 'display' ) != 'none'
        $('#arrow').fadeOut 600
    else
      if $('#arrow').css( 'display' ) == 'none'
        $('#arrow').fadeIn 600

    # nav bar scrolling

    $navBar = $('#navigation-bar-container')

    console.log $navBar.css 'top'

    if currentPos > navTop
      $navBar.addClass 'fixed-to-top'
    else
      $navBar.removeClass 'fixed-to-top'

    # name scrolling
    $name = $('#name')

    if currentPos > 80
      $name.addClass 'fixed-to-top'
    else
      $name.removeClass 'fixed-to-top'

    # if currentNavPos > 0
    #   return false

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

# to do : clicks on nav bar do a scrollTo animation
