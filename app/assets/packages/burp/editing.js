//
//= require jquery
//= require jquery.ui.draggable
//= require jquery.ui.droppable
//= require ../gritter/gritter.js
//= require ../../javascripts/burp/lib/fileupload.js
//= require ./editing/js/marked.js
//= require ./editing/js/markdown-fix.js
//= require ./editing/js/jquery.html2markdown.js
//= require ./editing/js/admin-dock.js
//= require ./editing/js/content-decorator.js
//= require ./editing/dep/CodeMirror-2.3/lib/codemirror.js
//= require ./editing/dep/CodeMirror-2.3/mode/javascript/javascript.js
//= require ./editing/dep/CodeMirror-2.3/mode/htmlmixed/htmlmixed.js
//= require ./editing/dep/CodeMirror-2.3/mode/xml/xml.js
//= require ./editing/dep/CodeMirror-2.3/mode/markdown/markdown.js
//= require ./editing/js/disableJavascript.js
//= require ./editing/js/snippets.js
//= require ./editing/js/main.js


$(function() {
  var csrf_token = $('meta[name=csrf-token]').attr('content');
  $.ajaxSetup({ headers: { "X-CSRF-Token": csrf_token } });
});
