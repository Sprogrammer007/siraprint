// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require galleria-1.4.2
//= require product
//= require uploader
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl

$(function () {
  $('[data-toggle="popover"]').popover({
    html: true,
    trigger: 'focus',
    placement: 'bottom'
  });

  $('.light-box').on('click', '.overlay, .close', function() {
    $('.light-box').removeClass('active');
  })

  if ($('.portfolio').length > 0) {

    $('.portfolio').on('click', '.portfolio-item', function(e) {

      var image = $(this).find('img').attr('src');
      $('.light-box').find('.the-image img').attr('src', image);
      $('.light-box').addClass('active');
    })
  }
})

