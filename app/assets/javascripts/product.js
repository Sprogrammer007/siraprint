var ready;

ready = function() {
  //Center modal
  function centerModal() {
    $(this).css('display', 'block');
    var $dialog = $(this).find(".modal-dialog");
    var offset = ($(window).height() - $dialog.height()) / 2;
    // Center modal vertically in window
    $dialog.css("margin-top", offset);
  }

  $('.modal').on('show.bs.modal', centerModal);
  $(window).on("resize", function () {
      $('.modal:visible').each(centerModal);
  });
  
  var $finishingOption, $form, $userType, $brokerDiscount, $lengthOption, $max_l, $max_w, $productOptions, $quantityOption, $thicknessOption, $unitOption, $url, $widthOption, calc_price, calc_sqft, change_price, change_price_calc, check_max_size, check_max_size_cb, convert_to_feet, convert_to_inch, currentItem, diecut_change, grommets_change, lamination_change, reset_finish_options, reset_values, round_numb, set_finish_price, set_per_unit_price, set_price, set_total_price, stretch_change, update_unit;
  $form = $('.order_form');
  $widthOption = $('.product-width');
  $lengthOption = $('.product-length');
  $unitOption = $('.product-unit');
  $quantityOption = $('.quantity-field');
  $thicknessOption = $('.thickness-selection');
  $finishingOption = $('.finishing-placeholder');
  $productOptions = $('#product-options');
  $url = $productOptions.data('price-url');
  $userType = $productOptions.data('u-type');
  $brokerDiscount = parseFloat($productOptions.attr('data-b-disc'));
  $max_w = parseInt($productOptions.attr('data-max-w'));
  $max_l = parseInt($productOptions.attr('data-max-l'));
  currentItem = {
    l_price: 0,
    g_price: 0,
    s_price: 0,
    dc_price: 0,
    sf_price: 0,
    rate: 0,
    fin_price: 0,
    unit_price: 0,
    before_discount_unit_price: 0,
    total_price: 0,
    resetFinishingPrice: function() {
      this.l_price = 0;
      this.g_price = 0;
      this.dc_price = 0;
      this.sf_price = 0;
      return this.fin_price = 0;
    }
  };
  $('.product-item').hover((function() {
    $(this).addClass("show");
  }), function() {
    $(this).removeClass("show");
  });

  error = function(e, t) {
    e.tooltip({container: 'body', trigger: 'manual'})
    e.attr('title', t).tooltip('fixTitle').tooltip('show')
  }
  convert_to_feet = function(x) {
    return parseFloat(Math.ceil((x * 0.083333) * 100) / 100).toFixed(2);
  };
  convert_to_inch = function(x) {
    return parseFloat(Math.floor(x * 12)).toFixed(0);
  };
  calc_sqft = function(w, l) {
    var unit;
    unit = $unitOption.find(':selected').val();
    if (unit === "inch") {
      return (w * l) / 144;
    } else {
      return w * l;
    }
  };
  calc_price = function(s, r) {
    return s * r;
  };
  round_numb = function(num) {
    return Math.round(num * 100) / 100;
  };
  update_unit = function(u, w, l) {
    var new_l, new_w;
    new_w = u === "inch" ? convert_to_inch(w) : convert_to_feet(w);
    new_l = u === "inch" ? convert_to_inch(l) : convert_to_feet(l);
    $widthOption.val(new_w);
    return $lengthOption.val(new_l);
  };
  reset_values = function() {
    currentItem.rate = 0;
    $widthOption.val(0);
    $lengthOption.val(0);
    $thicknessOption.prop('selectedIndex', 0);
    set_per_unit_price(0);
    set_finish_price(0);
    set_total_price(0);
    $quantityOption.val(1);
    return reset_finish_options(true);
  };
  set_per_unit_price = function(price) {
    currentItem.unit_price = parseFloat(round_numb(price));
    return $('.per-placeholder').html("$" + currentItem.unit_price);
  };  
  set_before_discount_per_unit_price = function(price) {
    if ($userType != "Broker") {return};
    currentItem.before_discount_unit_price = parseFloat(round_numb(price));
    return $('.before-per-placeholder').html("$" + currentItem.before_discount_unit_price);
  };
  set_finish_price = function(price) {
    currentItem.fin_price = parseFloat(round_numb(price));
    return $('.finishing-placeholder').html("$" + currentItem.fin_price);
  };
  set_total_price = function(price) {
    currentItem.total_price = parseFloat(round_numb(price));
    return $('.total-placeholder').html("$" + currentItem.total_price);
  };
  set_price = function(sqft, t_id) {
    var side;
    side = parseInt($('.side-selection').find(':selected').val());
    return $.post($url, {
      sqft: sqft,
      t_id: t_id
    }, void 0, "json").done(function(data) {
      var price;
      if (data === null) {
        reset_values();
        return alert("There are no matching sizes for your print, pelase re-enter width and length");
      } else {
        currentItem.rate = data.price;
        price = calc_price(sqft, data.price);
        if (side === 2) {
          price = price * 2;
        }
        set_before_discount_per_unit_price(price);
        if ($userType === "Broker" && $brokerDiscount !== 0) {
          price = (price - ((price * $brokerDiscount) / 100.0));
        }
        set_per_unit_price(price);
        return set_total_price(price);
      }
    });
  };
  change_price_calc = function(quantity, side) {
    var fin_price, price, before_discount_price, total_price;
    price = currentItem.unit_price;
    before_discount_price = currentItem.before_discount_unit_price;
    //apply discount
    if ($userType === "Broker" && $brokerDiscount !== 0) {
      price = (price - ((price * $brokerDiscount) / 100.0));
    }
    
    fin_price = 0;
    if (currentItem.l_price !== 0 || currentItem.g_price !== 0 || currentItem.dc_price !== 0 || currentItem.sf_price !== 0 || currentItem.s_price !== 0) {
      fin_price = currentItem.l_price + currentItem.g_price + currentItem.dc_price + currentItem.sf_price + currentItem.s_price;
      price = price + fin_price;
      before_discount_price += fin_price;
    }
    if (side === 2) {
      price = price * 2;
      before_discount_price = before_discount_price * 2;
      if (fin_price !== 0) {
        fin_price = (fin_price * 2) - + currentItem.s_price;
      }
    }
    set_before_discount_per_unit_price(before_discount_price);
    set_per_unit_price(price);
    set_finish_price(fin_price);
    if (quantity !== 0) {
      total_price = price * quantity;
    }
    if ($('#_orderexpress').is(':checked')) {
      total_price = total_price * 1.75
    }
    return set_total_price(total_price);
  };
  change_price = function(t_id) {
    var l, price, quantity, side, sqft, w;
    w = parseFloat($widthOption.val());
    l = parseFloat($lengthOption.val());
    quantity = parseInt($quantityOption.val());
    side = parseInt($('.side-selection').find(':selected').val());
    sqft = calc_sqft(w, l);
    price = calc_price(sqft, currentItem.rate);
    if (side && t_id !== void 0) {
      sqft = sqft * side;
    }
    if (quantity > 1 && t_id !== void 0) {
      sqft = sqft * quantity;
    }
    if (t_id !== void 0) {
      return $.post($url, {
        sqft: sqft,
        t_id: t_id
      }, void 0, "json").done(function(data) {
        if (data === null) {
          reset_values();
          return alert("There are no matching sizes for your print, pelase re-enter width and length");
        } else {
          currentItem.rate = data.price;
          price = calc_price(calc_sqft(w, l), data.price);
          set_before_discount_per_unit_price(price);
          set_per_unit_price(price);
          return change_price_calc(quantity, side);
        }
      });
    } else {
      set_before_discount_per_unit_price(price);
      set_per_unit_price(price);
      return change_price_calc(quantity, side);
    }
  };
  $form.on('change', '.product-unit', function(e) {
    var length, unit, width;
    unit = $(this).find(':selected').val();
    width = $widthOption.val();
    length = $lengthOption.val();
    update_unit(unit, width, length);
    return e.preventDefault();
  });
  check_max_size = function(w, l, u, that) {
    var max_l_f, max_w_f;
    max_l_f = convert_to_feet($max_l);
    max_w_f = convert_to_feet($max_w);
    if ($(that).hasClass('product-width')) {
      if (u === "inch") {
        if (l !== "" && l > $max_l && w > $max_w) {
          error(that, "maximum of 52 inch for either length or width");
          return false;
        }
      } else {
        if (l !== "" && l > max_l_f && w > max_w_f) {
          error(that, "maximum of 4.34 feet for either length or width");
          return false;
        }
      }
    } else {
      if (u === "inch") {
        if (w !== "" && w > $max_w && l > $max_l) {
          error(that, "maximum of 52 inch for either length or width");
          return false;
        }
      } else {
        if (w !== "" && w > max_w_f && l > max_l_f) {
          error(that, "maximum of 4.34 feet for either length or width");
          return false;
        }
      }
    }
    return true;
  };
  check_max_size_cb = function(w, l, u, that) {
    var max_l_f, max_w_f, min_size, min_size_f;
    max_l_f = parseFloat(convert_to_feet($max_l));
    max_w_f = parseFloat(convert_to_feet($max_w));
    if (u === "inch") {
      w = parseInt(w);
      l = parseInt(l);
      if ($max_w > $max_l) {
        min_size = $max_l;
      } else {
        min_size = $max_w;
      }
   
      if ((w !== "" && w === $max_w && l > $max_l) || (w !== "" && w === $max_l && l > $max_w)) {
        error(that, "maximum of " + $max_w + " x " + $max_l + " inch");
        return false;
      } else if ((l !== "" && l === $max_w && w > $max_l) || (l !== "" && l === $max_l && w > $max_w)) {
        error(that, "maximum of " + $max_w + " x " + $max_l + " inch");
        return false;
      } else if ((w !== "" && w > min_size && l > min_size) || (l !== "" && l > min_size && w > min_size)) {
        error(that, "One of your side must be lesser or equal to " + min_size + " inch");
        return false;
      }
    } else {
      w = parseFloat(w);
      l = parseFloat(l);
      if (max_w_f > max_l_f) {
        min_size_f = max_l_f;
      } else {
        min_size_f = max_w_f;
      }
      if ((w !== "" && w === max_w_f && l > max_l_f) || (w !== "" && w === max_l_f && l > max_w_f)) {
        error(that, "maximum of " + max_w_f + " x " + max_l_f + " feet");
        return false;
      } else if ((l !== "" && l === max_w_f && w > max_l_f) || (l !== "" && l === max_l_f && w > max_w_f)) {
        error(that, "maximum of " + max_w_f + " x " + max_l_f + " feet");
        return false;
      } else if ((w !== "" && w > min_size_f && l > min_size_f) || (l !== "" && l > min_size_f && w > min_size_f)) {
        error(that, "One of your side must be lesser or equal to " + min_size_f + " feet");
        return false;
      }
    }
    return true;
  };


  $form.on('change', '.product-width, .product-length', function(e) {
    var length, t_id, unit, width;
    unit = $unitOption.find(':selected').val();
    width = $widthOption.val();
    length = $lengthOption.val();
    t_id = $thicknessOption.find(':selected').val();
    if ($(this).val() <= 0) {
      $(this).val('');
      error($(this), "Cannot be 0.")
      return
    }

    if ($max_l === 52 && $max_w === 52) {
      if (!check_max_size(width, length, unit, $(this))) {
        $(this).val('');
        return;
      }
    } else {
      if (!check_max_size_cb(width, length, unit, $(this))) {
        $(this).val('');
        return;
      }
    }
    $(this).tooltip('hide');
    if (currentItem.rate !== 0 && t_id !== void 0 && t_id !== '') {
      return change_price(t_id);
    }
  });
  $form.on('focus', '.product-width, .product-length', function(e) {
    var thickness;
    thickness = $thicknessOption.find(':selected').val();
    if (currentItem.rate !== 0 && thickness !== void 0 && thickness === '') {
      error($thicknessOption, "Please select a thickness");
      $(this).blur();
      return false;
    }
  });

  $form.on('change', '.side-selection ', function() {
    var side, t_id;
    t_id = $thicknessOption.find(':selected').val();
    side = $(this).find(':selected').val();
    if (t_id !== void 0 && t_id !== '') {
      return change_price(t_id);
    }
  });

  $form.on('change', '.thickness-selection', function(e) {
    var id, length, sqft, width;
    id = $(this).find(':selected').val();
    if (id === '') {
      return;
    }
    width = $widthOption.val();
    length = $lengthOption.val();
    sqft = calc_sqft(width, length);
    if (width === "") {
      $(this).prop('selectedIndex', 0);
      return error($widthOption , "You must enter a width");
    } else if (length === "") {
      $(this).prop('selectedIndex', 0);
      return error($lengthOption, "You must enter a length");
    }
    $(this).tooltip('hide');
    if (currentItem.rate !== 0) {
      return change_price(id);
    } else {
      return set_price(sqft, id);
    }
  });
  reset_finish_options = function(checked) {
    if (checked) {
      $('#finishing_none').prop('checked', true);
      $('.finish-select').each(function(i) {
        if (i !== 0) {
          return $(this).prop('checked', false);
        }
      });
      currentItem.resetFinishingPrice();
      $('.grommets-box').addClass('hidden');
      $('.grommets-field').val(0);   
      return 
    }
  };
  grommets_change = function(checked) {
    if (checked) {
      return $('.grommets-box').removeClass('hidden');
    } else {
      $('.grommets-box').addClass('hidden');
      currentItem.g_price = 0;
      return $('.grommets-field').val(0);
    }
  };  

  lamination_change = function(checked, w, l) {
    var sqft;
    sqft = calc_sqft(w, l);
    if (checked) {
      return currentItem.l_price = parseFloat(round_numb(sqft));
    } else {
      return currentItem.l_price = 0;
    }
  };
  diecut_change = function(checked, w, l) {
    var sqft;
    sqft = calc_sqft(w, l);
    if (checked) {
      return currentItem.dc_price = parseFloat(round_numb(sqft * 5));
    } else {
      return currentItem.dc_price = 0;
    }
  };
  stretch_change = function(checked, w, l) {
    var sqft;
    sqft = calc_sqft(w, l);
    if (checked) {
      return currentItem.sf_price = parseFloat(round_numb(sqft * 3));
    } else {
      return currentItem.sf_price = 0;
    }
  };

  $form.on('change', '.finish-select', function() {
    var l, number_of_checked, option, w;
    w = $widthOption.val();
    l = $lengthOption.val();
    number_of_checked = $('.finish-select:checked').length;
    if (w === "") {
      $(this).prop('checked', false);
      return error($widthOption , "You must enter a width");
    } else if (l === "") {
      $(this).prop('selectedIndex', 0);
      return error($lengthOption, "You must enter a length");
    } else if (currentItem.rate === 0) {
      $(this).prop('checked', false);
      return error($thicknessOption ,"You must enter a select a thickness");
    }
    option = $(this).val();
    if (this.checked && option !== 'None') {
      $('#finishing_none').prop('checked', false);
    } else if (!this.checked && number_of_checked === 0) {
      $('#finishing_none').prop('checked', true);
    }

    if (option === "Grommets") {
      grommets_change(this.checked);
    } else if (option === "Step Sticks") {
      if (this.checked) {
        quantity = parseInt($('.quantity-field').val());
        currentItem.s_price = parseFloat(quantity * 0.80)
      } else {
        currentItem.s_price = 0
      } 
        
     
    } else if (option === "Gloss lamination") {
      if ($("#finishing_4").is(':checked')) {
        $("#finishing_4").prop('checked', false);
      }
      lamination_change(this.checked, w, l);
    } else if (option === "Matte Lamination") {
      if ($("#finishing_3").is(':checked')) {
        $("#finishing_3").prop('checked', false);
      }
      lamination_change(this.checked, w, l);
    } else if (option === "Die Cutting") {
      diecut_change(this.checked, w, l);
    } else if (option === "Stretch on Frame") {
      stretch_change(this.checked, w, l);
    } else if (option === "None") {
      reset_finish_options(this.checked);
    }
    return change_price();
  });

  $form.on('change', '.grommets-field', function() {
    var gq = $(this).val();
    if (gq < 1) {
      $(this).val(1);
      gq = 1;
      error($(this), "Atleast One");
    }
    $(this).tooltip('hide');
    currentItem.g_price = parseInt(gq);
    return change_price();
  });


  function plastic_card_price(q) {
    var id = $('#_orderproduct_id').val();
    if (q < 1) { return }

    $.post($url, {id: id, q: q}, 0, "json").done(function(data) { 
      var price;
      if (data === null) {
        alert("no price found");
        set_before_discount_per_unit_price(0);
        set_per_unit_price(0);
        set_total_price(0);
      } else {

        price = parseFloat(data.rate) * parseFloat(q);
        set_before_discount_per_unit_price(price);
        if ($userType === "Broker" && $brokerDiscount !== 0) {
          price = (price - ((price * $brokerDiscount) / 100.0));
        }
        if ($('#_orderexpress').is(':checked')) {
          price = price * 1.75
        }
        set_per_unit_price(price);
        set_total_price(price);
      }
    });
  };

  $form.on('change', '.quantity-field', function(e) {
    var price, quantity, t_id, type;
    quantity = parseInt($(this).val());
    price = currentItem.unit_price;
    type = $('#_orderproduct_type').val();
    t_id = $thicknessOption.find(':selected').val();
    if (price === 0 && type !== 'plastic_card') {
      return $(this).val(1);
    } else if (quantity < 1) {
      $(this).val(1);
      return error($(this), "Atleast One");
           
    } else if (t_id && t_id !== 0) {
      $(this).tooltip('hide');
      if (currentItem.s_price !== 0) {
          currentItem.s_price = parseFloat(quantity * 0.80)
      }
      return change_price(t_id);
      
    } else if (type === "metal_sign") {
      $(this).tooltip('hide');
      price = price * quantity;
      return set_total_price(price);
    } else if (type === "plastic_card") {
      $(this).tooltip('hide');
      plastic_card_price(quantity);
      return 
    }
  });
  $form.on('change', '#_orderexpress', function(e) {
    quantity = parseInt($(this).val());
    t_id = $thicknessOption.find(':selected').val();
    price = currentItem.unit_price;
    type = $('#_orderproduct_type').val();
    if (price === 0 && type !== 'plastic_card') {
      $(this).attr('checked', false)
    } else if (t_id && t_id !== 0) {
      $(this).tooltip('hide');
       return change_price(t_id);
 
    } else if (type === "metal_sign") {
     
      price = price * 1.75;
      return set_total_price(price);
    } else if (type === "plastic_card") {
     
      plastic_card_price(quantity);
      return 
    }
    
  });
  $('.qty-update-button').click(function(e) {
    var quantity, url;
    e.preventDefault();
    quantity = $(this).parents().prev("input").val();
    url = $(this).attr('data-url');
    return $.post(url, {
      quantity: quantity
    }, 0, "script");
  });

  $('.sign-item-size').on('change', 'select', function() {
    var index, s_id, that;
    that = $(this);
    index = that[0].selectedIndex;
    s_id = that.find(':selected').val();
    if (index !== 0) {
      return $.post($url, {
        s_id: s_id
      }, 0, "json").done(function(data) {
        var price;
        if (data === null) {
          alert("no signed found");
          set_before_discount_per_unit_price(0);
          set_per_unit_price(0);
          return set_total_price(0);
        } else {
          price = parseFloat(data.price) * parseFloat($quantityOption.val());
          set_before_discount_per_unit_price(price);
          if ($userType === "Broker" && $brokerDiscount !== 0) {
            price = (price - ((price * $brokerDiscount) / 100.0));
          }
          set_per_unit_price(price);
          return set_total_price(price);
        }
      });
    } else {
      set_before_discount_per_unit_price(0);
      set_per_unit_price(0);
      return set_total_price(0);
    }
  });

  $form.find('form').submit(function(e) {
    console.log('Testse')
    if ($('#fileupload').length > 0) { e.preventDefault(); return }
    e.preventDefault();
    var e = false;
    if ($(this).hasClass('large-formats-form')) {
      if ($widthOption.val() === '') {
        error($widthOption, "Enter width");
        e = true;
      } else if ($lengthOption.val() === '') {
        error($widthOption, "Enter length");
        e = true;
      } else if ($thicknessOption.val() === '') {
        error($thicknessOption, 'Select Thickness')
        e = true;
      } else if ($('input[value="Grommets"]').is(':checked') && $('.grommets-field').val() === '')  {
        error($('.grommets-field'), 'Enter # Grommets');
        e = true;
      } else if ($('input[value="Step Sticks"]').is(':checked') && $('.stick-field').val() === '')  {
        error($('.stick-field'), 'Enter # Step Sticks');
        e = true;
      };
    };

    if (e) { return };
    var data = $(this).serialize();
    var url = $(this).attr('action');
    $.post(url, data, null, 'script' );
  });

  $('.xaupload').on('click', function(e) {
    $('.delivery-btn').tooltip('hide')
  });

  $('.delivery-btn').click(function(e) {
    if ($('.xaupload').length > 0 ) {
      e.preventDefault();
      $(this).tooltip({container: 'body', trigger: 'manual', title: 'Some orders still requires design uploads.'});
      $(this).tooltip('show')
    }
  });
};

$(document).ready(ready);

