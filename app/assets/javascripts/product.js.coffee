ready = ->

  $form = $('.order_form')
  $widthOption =  $('.product-width')
  $lengthOption = $('.product-length')
  $unitOption = $('.product-unit')
  $quantityOption = $('.quantity-field')
  $thicknessOption = $('.thickness-selection')
  $finishingOption = $('.finishing-placeholder')
  $productOptions = $('#product-options')
  $url = $productOptions.data('price-url')
  $unitPrice = $('#_orderunit_price')
  $max_w = parseInt($productOptions.attr('data-max-w'))
  $max_l = parseInt($productOptions.attr('data-max-l'))

  # Overlay for product items
  $('.product-item').hover (->
    $(this).addClass "show"
    return
  ), ->
    $(this).removeClass "show"
    return

  convert_to_feet = (x) ->
    return parseFloat(Math.ceil((x * 0.083333) * 100) / 100).toFixed(2)

  convert_to_inch = (x) ->
    return parseFloat(Math.floor(x * 12)).toFixed(0)

  calc_sqft = (w, l) ->
    unit = $unitOption.find(':selected').val()

    if (unit == "inch")
      return ((w * l)/144)
    else
      return (w * l)

  # Calc Price
  calc_price = (s, r) ->
    return (s * r)

  round_numb = (num) ->
    return parseFloat(Math.round(num * 100) / 100)

  # Update Unit
  update_unit = (u, w, l)->
    new_w = if u == "inch" then convert_to_inch(w) else convert_to_feet(w)
    new_l = if u == "inch" then convert_to_inch(l) else convert_to_feet(l)
    $widthOption.val(new_w)
    $lengthOption.val(new_l)

  reset_values = ->
    $productOptions.attr('data-rate', '')
    $widthOption.val(0)
    $lengthOption.val(0)
    $thicknessOption.prop('selectedIndex', 0)
    set_per_unit_price(0)
    set_total_price(0)
    $quantityOption.val(1)

  set_per_unit_price = (price) ->
    $unitPrice.val(price)
    $('.per-placeholder').html("$#{price}")
  
  set_finish_price = (price) ->
    $productOptions.attr('data-fin-price', price)
    $('.finishing-placeholder').html("$#{price}")

  set_total_price = (price) ->
    $('#_ordertotal_price').val(price)
    $('.total-placeholder').html("$#{price}")

  set_price = (sqft, t_id) ->
    side = parseInt($('.side-selection').find(':selected').val())
    $.post($url, sqft: sqft, t_id: t_id, undefined, "json").done (data) ->
      if data == null
        reset_values()
        alert("There are no matching sizes for your print, pelase re-enter width and length")
      else
        $productOptions.attr('data-rate', data.price)
        price = round_numb(calc_price(sqft, data.price))

        if side == 2
          price = price * 2.0

        set_per_unit_price(price)
        set_total_price(price)
          
  # Change Price

  change_price_calc = (price, quantity, side)->
    l_price = parseFloat($productOptions.attr('data-l-price'))
    g_price = parseFloat($productOptions.attr('data-g-price'))

    if ( l_price != '' || g_price != '')
      f_price = round_numb(l_price + g_price)
      price = price + parseFloat(f_price)
      price = round_numb(price) 
      
    if side == 2
      price = price * 2.0
      f_price = f_price * 2.0

    set_per_unit_price(price)
    set_finish_price(f_price)

    if (quantity != 0)
      price = price * parseFloat(quantity)

    set_total_price(price)

  change_price = (t_id) ->
    w = $widthOption.val()
    l = $lengthOption.val()
    quantity = parseFloat($quantityOption.val())
    side = parseInt($('.side-selection').find(':selected').val())
    sqft = parseFloat(calc_sqft(w, l))
    rate = $productOptions.attr('data-rate')
    price = round_numb(calc_price(sqft, rate))

    if side && t_id != undefined
      sqft = sqft * side

    if quantity > 1 && t_id != undefined
      sqft = sqft * quantity
  
    if t_id != undefined
      $.post($url, sqft: sqft, t_id: t_id,undefined, "json").done (data) ->

        if data == null
          reset_values()
          alert("There are no matching sizes for your print, pelase re-enter width and length")
        else
          $productOptions.attr('data-rate', data.price)
          price = round_numb(calc_price(calc_sqft(w, l), data.price))
          change_price_calc(price, quantity, side)
    else
      change_price_calc(price, quantity)


  # Change Unit
  $form.on 'change', '.product-unit', (e) ->
    unit = $(this).find(':selected').val()
    width = $widthOption.val()
    length = $lengthOption.val()
    update_unit(unit, width, length)
    e.preventDefault()

  check_max_size = (w, l, u, that) ->
    max_l_f = convert_to_feet($max_l)
    max_w_f = convert_to_feet($max_w)
    if ($(that).hasClass('product-width'))
      if (u == "inch")
        if (l != "" && l > $max_l && w > $max_w)   
          alert("There is a maximum of 52 inch for either length or width")
          return false
      else
        if (l != "" && l >  max_l_f && w > max_w_f) 
          alert("There is a maximum of 4.34 feet for either length or width")
          return false
    else
      if (u == "inch")
        if (w != "" && w > $max_w && l > $max_l)
          alert("There is a maximum of 52 inch for either length or width")
          return false
      else
        if (w != "" && w > max_w_f && l > max_l_f) 
          alert("There is a maximum of 4.34 feet for either length or width")
          return false
    return true

  check_max_size_cb = (w, l, u) ->
    max_l_f = parseFloat(convert_to_feet($max_l))
    max_w_f = parseFloat(convert_to_feet($max_w))
    
    if (u == "inch")
      w = parseInt(w)
      l = parseInt(l)
      if ($max_w > $max_l) 
        min_size = $max_l 
      else
        min_size = $max_w

      if (w !="" && w == $max_w && l > $max_l) || (w !="" && w == $max_l && l > $max_w)
        alert("There is a maximum of #{$max_w} x #{$max_l} inch")
        return false
      else if (l !="" && l == $max_w && w > $max_l) || (l !="" && l == $max_l && w > $max_w)
        alert("There is a maximum of #{$max_w} x #{$max_l} inch")
        return false
      else if (w !="" && w > min_size && l > min_size) || (l !="" && l > min_size && w > min_size)
        alert("One of your side must be lesser or equal to #{min_size} inch")
        return false 
    else
      w = parseFloat(w)
      l = parseFloat(l)
      if (max_w_f > max_l_f) 
        min_size_f = max_l_f 
      else
        min_size_f = max_w_f
      if (w !="" && w == max_w_f && l > max_l_f) || (w !="" && w == max_l_f && l > max_w_f)
        alert("There is a maximum of #{max_w_f} x #{max_l_f} feet")
        return false
      else if (l !="" && l == max_w_f && w > max_l_f) || (l !="" && l == max_l_f && w > max_w_f)
        alert("There is a maximum of #{max_w_f} x #{max_l_f} feet")
        return false
      else if (w !="" && w > min_size_f && l > min_size_f) || (l !="" && l > min_size_f && w > min_size_f)
        alert("One of your side must be lesser or equal to #{min_size_f} feet")
        return false 

    return true

  # Change Width Length
  $form.on 'change', '.product-width, .product-length', (e) ->
    unit = $unitOption.find(':selected').val()
    width = $widthOption.val()
    length = $lengthOption.val()
    rate = $productOptions.attr('data-rate')
    t_id = $thicknessOption.find(':selected').val()

    if ($(this).val() <= 0)
      $(this).val('')
      return alert("width or length cannot be 0")

    if $max_l == 52 && $max_w == 52
      if !check_max_size(width, length, unit, this)
        $(this).val('')
        return
    else
      if !check_max_size_cb(width, length, unit)
        $(this).val('')
        return
      
    if (rate != '' && t_id != undefined && t_id != '')
      change_price(t_id)  

  $form.on 'focus', '.product-width, .product-length', (e)->
    rate = $productOptions.attr('data-rate')
    thickness = $thicknessOption.find(':selected').val()
    if (rate != '' && thickness != undefined && thickness == '')
      alert("Please select a thickness")
      $(this).blur()
      return false

  # Change Side
  $form.on 'change', '.side-selection ', ()->
    t_id = $thicknessOption.find(':selected').val()
    side = $(this).find(':selected').val()

    if side == "2"
      $('.file_2').removeClass('hidden')
    else
      $('.file_2').addClass('hidden')
      
    if (t_id != undefined && t_id != '')
      change_price(t_id)

  $form.on 'change', '.thickness-selection', (e)->
    id = $(this).find(':selected').val()

    if (id == '')
      return

    width = $widthOption.val()
    length = $lengthOption.val()
    sqft = calc_sqft(width, length)
    rate = $productOptions.attr('data-rate')

    if (width == "" || length == "")
      $(this).prop('selectedIndex', 0)
      return alert("You must enter a length & width")

    if (rate != '') then change_price(id) else set_price(sqft, id)
    
  #  Finish Options
  grommets_change = (checked)->
    if checked
      $('.grommets-box').removeClass('hidden')
    else
      $('.grommets-box').addClass('hidden')
      $productOptions.attr('data-g-price', 0)
      $('.grommets-field').val(0)
  
  lamination_change = (checked, w, l) ->
    sqft = calc_sqft(w, l)
    if checked
      l_price = parseFloat(sqft).toFixed(2) 
      $productOptions.attr('data-l-price', l_price)
    else
      $productOptions.attr('data-l-price', 0)

  reset_finish_options = (checked) ->
    if checked
      $('#finishing_none').attr('checked', true)
      $('.finish-select').each (i)->
        if i != 0
          $(this).attr('checked', false)
      $productOptions.attr('data-l-price', 0)
      $productOptions.attr('data-g-price', 0)
      $productOptions.attr('data-fin-price', 0)
      $('.grommets-box').addClass('hidden')
      $('.grommets-field').val(0)

  $form.on 'change', '.finish-select', ->
    w = $widthOption.val()
    l = $lengthOption.val()
    r = $productOptions.attr('data-rate')

    if (w == "" || l == "")
      $(this).prop('checked', false)
      return alert("You must enter a length & width")
    else if (r == "")
      $(this).prop('checked', false)
      return alert("You must enter a select a thickness")

    option = $(this).val()
   
    if this.checked && option != 'None'
      $('#finishing_none').attr('checked', false)
    console.log(option)
    if option == "Grommets"
      grommets_change(this.checked)
    else if (option == "Lamination" || option == "Gloss Lamination" || option == "Matte Lamination")
      lamination_change(this.checked, w, l)
    else if option == "None"
      reset_finish_options(this.checked)

    change_price()
  
  # Grommet Quantity Change
  $form.on 'change', '.grommets-field', ->
    gq = $(this).val()

    if (gq < 1)
      $(this).val(1)
      gq = 1
      alert("Number of prints must be atleast 1")
    $productOptions.attr('data-g-price', gq)

    change_price()

  # Quantity Change
  $form.on 'change', '.quantity-field', (e) ->
    quantity = $(this).val()
    price = parseFloat($('.per-placeholder').html().replace("$", ''))
    t_id = $thicknessOption.find(':selected').val()

    if (price == 0)
      $(this).val(1)
    else if (quantity < 1)
      $(this).val(1)
      alert("Number of prints must be atleast 1")
    else if (price == '')
      $(this).val(1)
    else
      change_price(t_id)

  # Update Quantity for Order Page
  $('.qty-update-button').click (e) ->
    e.preventDefault()
    quantity = $(this).parents().prev("input").val()
    url = $(this).attr('data-url')
    $.post(url, {quantity: quantity} , undefined, "script")

  # Metal Signs
  $('.sign-item-size').on 'change', 'select', () ->
    that = $(this)
    index = that[0].selectedIndex
    s_id = that.find(':selected').val()
    
    if index != 0
     $.post($url, s_id: s_id, undefined, "json").done (data) ->
        if data == null
          alert("no signed found")
          set_per_unit_price(0)
          set_total_price(0)
        else
          price = data.price * $quantityOption.val()
          set_per_unit_price(price)
          set_total_price(price)
    else
      set_per_unit_price(0)
      set_total_price(0)
      
  # Validation Before Submit
  $('.order_form').on 'submit', "form", (e)->
    side = $('.side-selection').find(':selected').val()
    if $('#_orderdesign_pdf').val() == ""
      $('#_orderdesign_pdf').parents('.input-group').next('.error').removeClass("hidden")
      e.preventDefault()

    if side == "2" && $('#_orderdesign_pdf_2').val() == ""
      $('#_orderdesign_pdf_2').parents('.input-group').next('.error').removeClass("hidden")
      e.preventDefault()

  # File Upload
  $form.on 'change', '.btn-file :file', ->
    input = $(this)  
    numFiles = (if input.get(0).files then input.get(0).files.length else 1)
    label = input.val().replace(/\\/g, "/").replace(/.*\//, "")
    input.trigger "fileselect", [
      numFiles
      label
    ]
    return
  
  $form.on "fileselect", ".btn-file :file", (event, numFiles, label) ->
    input = $(this).parents(".input-group").find(":text")
    log = (if numFiles > 1 then numFiles + " files selected" else label)
    if input.length
      input.val log
    else
      alert log  if log
    return
   
$(document).ready(ready)
$(document).on('page:load', ready)


