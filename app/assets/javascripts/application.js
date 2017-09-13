// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .
//= require filterrific/filterrific-jquery

// Javascript to check_all boxes
$('#selectAll').click(function (e) {
    $(this).closest('table').find('td input:checkbox').prop('checked', this.checked);
});

$(document).ready(function() {
  //mouse over navbar
  $('.navbar').mouseover(function(event) {
    $(this).find('.navbar-tool').show();
  });

  //mouse out of navbar
  $('.navbar').mouseout(function(event) {
    $(this).find('.navbar-tool').hide();
  });

  //on close collapse
  $('.collapse').on('hidden.bs.collapse', function () {
    var target = '#'+$(this).attr('data-parent');
    $(target).removeClass('collapse-open');
  });

  //on open collapse
  $('.collapse').on('shown.bs.collapse', function () {
    var target = '#'+$(this).attr('data-parent');
    $(target).addClass('collapse-open');
  })

});
