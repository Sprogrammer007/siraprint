var ready;

ready = function() {


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
    dc_price: 0,
    sf_price: 0,
    rate: 0,
    fin_price: 0,
    unit_price: 0,
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
        if ($userType === "Broker" && $brokerDiscount !== 0) {
          price = (price - ((price * $brokerDiscount) / 100.0));
        }
        set_per_unit_price(price);
        return set_total_price(price);
      }
    });
  };
  change_price_calc = function(quantity, side) {
    var fin_price, price, total_price;
    price = currentItem.unit_price;

    //apply discount
    if ($userType === "Broker" && $brokerDiscount !== 0) {
      price = (price - ((price * $brokerDiscount) / 100.0));
    }
    
    fin_price = 0;
    if (currentItem.l_price !== 0 || currentItem.g_price !== 0 || currentItem.dc_price !== 0 || currentItem.sf_price !== 0) {
      fin_price = currentItem.l_price + currentItem.g_price + currentItem.dc_price + currentItem.sf_price;
      price = price + fin_price;
    }
    if (side === 2) {
      price = price * 2;
      if (fin_price !== 0) {
        fin_price = fin_price * 2;
      }
    }

    set_per_unit_price(price);
    set_finish_price(fin_price);
    if (quantity !== 0) {
      total_price = price * quantity;
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
          set_per_unit_price(price);
          return change_price_calc(quantity, side);
        }
      });
    } else {
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
          alert("There is a maximum of 52 inch for either length or width");
          return false;
        }
      } else {
        if (l !== "" && l > max_l_f && w > max_w_f) {
          alert("There is a maximum of 4.34 feet for either length or width");
          return false;
        }
      }
    } else {
      if (u === "inch") {
        if (w !== "" && w > $max_w && l > $max_l) {
          alert("There is a maximum of 52 inch for either length or width");
          return false;
        }
      } else {
        if (w !== "" && w > max_w_f && l > max_l_f) {
          alert("There is a maximum of 4.34 feet for either length or width");
          return false;
        }
      }
    }
    return true;
  };
  check_max_size_cb = function(w, l, u) {
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
        alert("There is a maximum of " + $max_w + " x " + $max_l + " inch");
        return false;
      } else if ((l !== "" && l === $max_w && w > $max_l) || (l !== "" && l === $max_l && w > $max_w)) {
        alert("There is a maximum of " + $max_w + " x " + $max_l + " inch");
        return false;
      } else if ((w !== "" && w > min_size && l > min_size) || (l !== "" && l > min_size && w > min_size)) {
        alert("One of your side must be lesser or equal to " + min_size + " inch");
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
        alert("There is a maximum of " + max_w_f + " x " + max_l_f + " feet");
        return false;
      } else if ((l !== "" && l === max_w_f && w > max_l_f) || (l !== "" && l === max_l_f && w > max_w_f)) {
        alert("There is a maximum of " + max_w_f + " x " + max_l_f + " feet");
        return false;
      } else if ((w !== "" && w > min_size_f && l > min_size_f) || (l !== "" && l > min_size_f && w > min_size_f)) {
        alert("One of your side must be lesser or equal to " + min_size_f + " feet");
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
      return alert("width or length cannot be 0");
    }
    if ($max_l === 52 && $max_w === 52) {
      if (!check_max_size(width, length, unit, this)) {
        $(this).val('');
        return;
      }
    } else {
      if (!check_max_size_cb(width, length, unit)) {
        $(this).val('');
        return;
      }
    }
    if (currentItem.rate !== 0 && t_id !== void 0 && t_id !== '') {
      return change_price(t_id);
    }
  });
  $form.on('focus', '.product-width, .product-length', function(e) {
    var thickness;
    thickness = $thicknessOption.find(':selected').val();
    if (currentItem.rate !== 0 && thickness !== void 0 && thickness === '') {
      alert("Please select a thickness");
      $(this).blur();
      return false;
    }
  });
  $form.on('change', '.side-selection ', function() {
    var side, t_id;
    t_id = $thicknessOption.find(':selected').val();
    side = $(this).find(':selected').val();
    if (side === "2") {
      $('.file_2').removeClass('hidden');
    } else {
      $('.file_2').addClass('hidden');
    }
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
    if (width === "" || length === "") {
      $(this).prop('selectedIndex', 0);
      return alert("You must enter a length & width");
    }
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
      return $('.grommets-field').val(0);
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
    if (w === "" || l === "") {
      $(this).prop('checked', false);
      return alert("You must enter a length & width");
    } else if (currentItem.rate === 0) {
      $(this).prop('checked', false);
      return alert("You must enter a select a thickness");
    }
    option = $(this).val();
    if (this.checked && option !== 'None') {
      $('#finishing_none').prop('checked', false);
    } else if (!this.checked && number_of_checked === 0) {
      $('#finishing_none').prop('checked', true);
    }
    if (option === "Grommets") {
      grommets_change(this.checked);
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
    var gq;
    gq = $(this).val();
    if (gq < 1) {
      $(this).val(1);
      gq = 1;
      alert("Number of prints must be atleast 1");
    }
    currentItem.g_price = parseInt(gq);
    return change_price();
  });
  $form.on('change', '.quantity-field', function(e) {
    var price, quantity, t_id;
    quantity = parseInt($(this).val());
    price = currentItem.unit_price;
    t_id = $thicknessOption.find(':selected').val();
    if (price === 0) {
      return $(this).val(1);
    } else if (quantity < 1) {
      $(this).val(1);
      return alert("Number of prints must be atleast 1");
    } else if (t_id !== void 0) {
      return change_price(t_id);
    } else if ($('#_orderproduct_type').val() === "metal_sign") {
      price = price * quantity;
      return set_total_price(price);
    }
  });
  $('.qty-update-button').click(function(e) {
    var quantity, url;
    e.preventDefault();
    quantity = $(this).parents().prev("input").val();
    url = $(this).attr('data-url');
    return $.post(url, {
      quantity: quantity
    }, void 0, "script");
  });

  $('.sign-item-size').on('change', 'select', function() {
    var index, s_id, that;
    that = $(this);
    index = that[0].selectedIndex;
    s_id = that.find(':selected').val();
    if (index !== 0) {
      return $.post($url, {
        s_id: s_id
      }, void 0, "json").done(function(data) {
        var price;
        if (data === null) {
          alert("no signed found");
          set_per_unit_price(0);
          return set_total_price(0);
        } else {
          price = parseFloat(data.price) * parseFloat($quantityOption.val());
          set_per_unit_price(price);
          return set_total_price(price);
        }
      });
    } else {
      set_per_unit_price(0);
      return set_total_price(0);
    }
  });

  $('.order_form').on('submit', "form", function(e) {
    var side, t_id;
    t_id = $thicknessOption.find(':selected').val();
    side = $('.side-selection').find(':selected').val();

    if (t_id === 'undefined') {
      alert("please select thickness")
      return e.preventDefault();
    }
    if ($('#_orderdesign_pdf').val() === "") {
      $('#_orderdesign_pdf').parents('.input-group').next('.error').removeClass("hidden");
      return e.preventDefault();
    }
    if (side === "2" && $('#_orderdesign_pdf_2').val() === "") {
      $('#_orderdesign_pdf_2').parents('.input-group').next('.error').removeClass("hidden");
      return e.preventDefault();
    }
  });


  $form.on('change', '.btn-file :file', function() {
    var input, label, numFiles;
    input = $(this);
    numFiles = (input.get(0).files ? input.get(0).files.length : 1);
    label = input.val().replace(/\\/g, "/").replace(/.*\//, "");
    input.trigger("fileselect", [numFiles, label]);
  });

  $form.on("fileselect", ".btn-file :file", function(event, numFiles, label) {
    var input, log;
    input = $(this).parents(".input-group").find(":text");
    log = (numFiles > 1 ? numFiles + " files selected" : label);
    if (input.length) {
      input.val(log);
    } else {
      if (log) {
        alert(log);
      }
    }
  });
};

$(document).ready(ready);

