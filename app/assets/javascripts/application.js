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
//= require bootstrap
//= require trix
//= require_tree .
//= require filterrific/filterrific-jquery
//= require moment
//= require bootstrap-datetimepicker
//= require cocoon
//= require select2
//= require typeahead.bundle.min
//= require jquery.inputmask.min

function validateFiles(inputFile) {
  var maxExceededMessage = "This file exceeds the maximum allowed file size (1 MB)";
  // var extErrorMessage = "Only image file with extension: .jpg, .jpeg, .gif or .png is allowed";
  // var allowedExtension = ["jpg", "jpeg", "gif", "png"];

  var extName;
  var maxFileSize  = $(inputFile).data('max-file-size');
  var sizeExceeded = false;

  $.each(inputFile.files, function () {
    if (this.size && maxFileSize && this.size > parseInt(maxFileSize)) {
      sizeExceeded = true;
    }

    extName = this.name.split('.').pop();
  });
  if (sizeExceeded) {
    window.alert(maxExceededMessage);
    $(inputFile).val('');
  }
}

// Javascript to check_all boxes
$('#selectAll').click(function (e) {
  $(this).closest('table').find('td input:checkbox').prop('checked', this.checked);
});

$(function () {
  $("select").select2({
    theme: "bootstrap"
  });

  $('#search.policy-number-search').inputmask({ mask: "9", repeat: 10 });
});