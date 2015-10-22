# application.coffee

addEmailLink = ->
  if $("#email") != null
    userName     = "aaron.zick"
    hostName     = "gmail.com"
    emailAddress = userName + "@" + hostName
    $("#email").replaceWith "<a href='mailto:" + emailAddress + "'>" + emailAddress + "</a>"

switchPage = ( pageToShow ) ->
  pageToHide = $('.work-page-button.selected').attr 'id'

  console.log pageToShow
  $( "[page='" + pageToHide + "'" ).fadeOut 100, ->
      $( "[page='" + pageToShow + "'" ).fadeIn 100, ->
        $( "[page='" + pageToShow + "'" ).removeClass 'hidden'
      $( "[page='" + pageToHide + "'" ).addClass 'hidden'

  $selected = $('.selected')

  if $selected != null
    $selected.removeClass 'selected'

  $("##{pageToShow}").addClass 'selected'

displayArrow = ->
  $("#arrow").delay( 700 ).animate { 'top': "#{$(window).height() - 54}px" }, 500

# to do : enum
pages = ['landing','about','work','gear','blog','contact']
page = 0

$(document).ready ->
  navTop = $('#'+pages[1]).position().top

  addEmailLink()
  displayArrow()
  # fixYoutubeEmbed()

  $(window).resize ->
    navTop = $(window).height() + 171
    handleScrollCase $('#landing').parent().scrollTop()

  $('#landing').parent().scroll ->
    handleScrollCase $(this).scrollTop()

  $('.work-page-button').on 'click', (e) ->
    e.preventDefault()
    switchPage( $(this).attr 'id' )


  handleScrollCase = ( top ) ->
    currentPos = top
    currentNavPos = $('#navigation-bar').position().top

    # arrow
    if currentPos > 10
      if $('#arrow').css( 'display' ) != 'none'
        $('#arrow').fadeOut 600
    else
      if $('#arrow').css( 'display' ) == 'none'
        $('#arrow').fadeIn 600

    percentageBGScroll = currentPost/10
    if percentageBGScroll > 100
      percentageBGScroll = 100
    if percentageBGScroll < 0
      percentageBGScroll = 0

    $('html').css('background-position-y',(percentageBGScroll)+'%')

    # nav bar scrolling
    smallDif = 0
    if $(window).width() <= 880
      smallDif = 91

    $navBar = $('#navigation-bar-container')
    if currentPos > (navTop - smallDif)
      $navBar.addClass 'fixed-to-top'
    else
      $navBar.removeClass 'fixed-to-top'

    # name scrolling
    $name = $('#name')

    if currentPos > 80
      $name.addClass 'fixed-to-top'
    else
      $name.removeClass 'fixed-to-top'

    for cur_page in pages
      if $('#'+cur_page).offset().top < 100 && $('#'+cur_page).offset().top > -$('#'+cur_page).height() && !$("#"+cur_page+"_button").is(':animated')
        $("#"+cur_page+"_button").addClass('current')
        $("#"+cur_page+"_button").removeClass('not_current')
      else
        $("#"+cur_page+"_button").removeClass('current')
        $("#"+cur_page+"_button").addClass('not_current')
