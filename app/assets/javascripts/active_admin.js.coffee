#= require active_admin/base
#= require tinymce-jquery


$(document).ready ->
  tinyMCE.init
    #General options
    mode : "textareas",
    theme : "modern",
    editor_selector: "tinymce"

  $('form').on 'click', '.remove_tier_fields, .remove_thickness_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_new_thickness, .add_new_tier', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    if $(this).hasClass('add_new_tier')
      $(this).parent().siblings('.large_print_tier_field_group').find(".w25").last()
      .before($(this).data('fields').replace(regexp, time).replace("Default Thickness", "New Thickness"))
    else
      $(this).parent().siblings('fieldset').last()
      .after($(this).data('fields').replace(regexp, time).replace("Default Thickness", "New Thickness"))
    event.preventDefault()

  $('.col-thicknesses').on 'click', '.view_thickness_details', (event) ->
    $('.material-detail-wrapper').html($(this).data('detail'))

  return