//
//= require jquery
//= require jquery.ui.draggable
//= require jquery.ui.droppable
//= require ../../javascripts/burp/fileupload.js
//= require ./editing/js/md5.js
//= require ./editing/js/showdown.js
//= require ./editing/js/stay.js
//= require ./editing/js/admin-dock.js
//= require ./editing/js/content-decorator.js
//= require ./editing/dep/CodeMirror-2.3/lib/codemirror.js
//= require ./editing/dep/CodeMirror-2.3/mode/javascript/javascript.js
//= require ./editing/dep/CodeMirror-2.3/mode/htmlmixed/htmlmixed.js
//= require ./editing/dep/CodeMirror-2.3/mode/xml/xml.js
//= require ./editing/dep/CodeMirror-2.3/mode/markdown/markdown.js
//= require ./editing/js/main.js


$(function() {
  var csrf_token = $('meta[name=csrf-token]').attr('content');
  $.ajaxSetup({ headers: { "X-CSRF-Token": csrf_token } });
});
