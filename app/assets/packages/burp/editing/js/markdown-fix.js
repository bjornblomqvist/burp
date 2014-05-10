/*global
  marked
*/

(function() {
  
  marked.setOptions({
    gfm: true,
    pedantic: false,
    sanitize: false
  });
  
  function includeForMarkdown(element) {
    // Include text
    if(element.nodeType === 3) {
      return true;
    } else if(element.nodeType === 1 && element.tagName.match(/^(b|big|i|small|tt|abbr|acronym|cite|code|dfn|em|kbd|strong|samp|var|a|bdo|br|img|map|object|q|script|span|sub|sup|button|input|label|select|textarea)$/i)) {
      return true;
    } else {
      return false;
    }
  }

  function mergeTextAndInlineNodes(nodes) {
    var newArray = [];
    $(nodes).each(function(index, element) {
      var last = newArray.length-1;
      if(includeForMarkdown(element)) {
        var data = (element.nodeType === 3) ? element.data : $("<div></div>").append(element).html();

        if(typeof(newArray[last]) === 'string') {
          newArray[last] = newArray[last] + data;
        } else {
          newArray.push(data);
        }
      } else {
        newArray.push(element);
      }
    });
    return newArray;
  }

  function toHtml(markdown) {

    var elements = [];

    $.each(mergeTextAndInlineNodes($("<div></div>").append(markdown).contents()), function(index, value) {
      if(typeof(value) === "string") {
        elements.push(marked(value));
      } else {
        elements.push(value);
      }
    });

    return $("<div></div>").append(elements).html();
  }
  
  window.markdown2Html = toHtml;
  
}());
