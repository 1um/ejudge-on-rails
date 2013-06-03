// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.9.1
//= require bootstrap
//= require best_in_place
//= require_tree .
$(document).ready(function(){
  dp.SyntaxHighlighter.ClipboardSwf = 'clipboard.swf';
  dp.SyntaxHighlighter.HighlightAll('code');
  jQuery(".best_in_place").best_in_place();
})

$('form#reload_ejudge').on('ajax:success',function(event, data, status, xhr){
  $('#ej-login').modal("show");
}).on('ajax:error',function(event, xhr, status, error){
  $("#stage form").submit();
});
