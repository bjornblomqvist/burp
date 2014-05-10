/*global
    
*/

(function(window) {

  if(typeof(window.burp) == "undefined") {
    window.burp = {};
  }
  
  function unescapeJavascript(script) {
    return script.replace(/&quot;/g,'"').replace(/&#39;/g,"'").replace(/&lt;/g,"<").replace(/&gt;/g,"<");
  }

  var javascript_warning_has_been_shown = false;

  function warnAboutJavascript() {
    if(!javascript_warning_has_been_shown) {
      $.gritter.add({
        title: 'WARNING!',
        text: ' Javascript found! The javascript will not be previewed but it will be saved.<br><br>Save and reload to test the javascript.',
        time: 20000
      });
    
      javascript_warning_has_been_shown = true;
    }
  }
  
  function disableScriptElements(elements) {
    $(elements).each(function() {
      if($(this).is("script")) {
        $(this).text(unescapeJavascript($(this).text()));
        $(this).attr('type','text/dont-run-javascript');
        warnAboutJavascript();
      } else {
        $(this).find('script').each(function() {
          $(this).text(unescapeJavascript($(this).text()));
          $(this).attr('type','text/dont-run-javascript');
          warnAboutJavascript();
        });
      }
    });
    
    return elements;
  }

  window.burp.disableScriptElements = disableScriptElements;

}(window));