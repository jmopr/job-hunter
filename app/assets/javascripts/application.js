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

$(document).ready(function(){
  $('input[name="commit"]').val('Update Resume').attr('disabled', true);
  $('#user_document').bind("click", function(){
    if($('#user_document')[0].files.length == 0)
      $('input[name="commit"]').val('Update Resume').attr('disabled', false);
    else
      $('input[name="commit"]').val('Update Resume').attr('disabled', true);
    });
});

// $(document).ready(function(){
  // $('input[name="_method"]').val('delete').click(function(){
  //     alert("Are you sure you want to delete the jobs?");
  // });
  // $('input[type="submit"]').val('Apply to Jobs').click(function(){
  //     alert("Are you sure you want to delete the jobs?");
  // });
// });
