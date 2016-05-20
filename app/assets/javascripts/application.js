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
//= require react
//= require react_ujs
//= require components
//= require_tree .

$(document).on("page:change", function(){

  // Disable Resume button if empty.
  $('input[value="Update Resume"]').attr('disabled', true);
  $('#user_document').on("change", function(){
    if($('#user_document').val() == 0)
      $('input[value="Update Resume"]').attr('disabled', true);
    else
      $('input[value="Update Resume"]').attr('disabled', false);
  });

  // Confirm deletion of jobs.
  $('input[value="Delete Jobs"]').click(function(){
      return confirm('Are you sure you want to delete this item?');
  });
  $('input[value="Delete Selected Jobs"]').click(function(){
      return confirm('Are you sure you want to delete this item?');
  });

  // Disable pages text input until indeed option is clicked.
  $('#pages').attr('disabled', true);

  // Uncheck a box when checking another one.
  $('input[name="indeed_scraper"]').on('change', function() {
    $('#pages').attr('disabled', false);
    $('input[name="angel_scraper"]').not(this).prop('checked', false);
  });
  $('input[name="angel_scraper"]').on('change', function() {
    $('#pages').attr('disabled', true);
    $('input[name="indeed_scraper"]').not(this).prop('checked', false);
  });

  // Match and apply page.
  $('input[name="indeed_applier"]').on('change', function() {
    $('input[name="angel_applier"]').not(this).prop('checked', false);
  });
  $('input[name="angel_applier"]').on('change', function() {
    $('input[name="indeed_applier"]').not(this).prop('checked', false);
  });

  // $('input[type="checkbox"]').on("change", function() {
  //   if($('input[type="checkbox"]').prop('checked', false))
  //     $('input[value="Find Jobs"]').attr('disabled', true);
  //   else
  //     $('input[value="Find Jobs"]').attr('disabled', false);
  // });
});
