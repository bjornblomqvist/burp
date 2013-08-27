(function(window,jQuery) {
  
  var $ = jQuery;
  
  window.snippets = function() {
    
    var snippets = {names:[],snippets:{}};
    
    var snippetComments = $("*:not(iframe)").contents().filter(function() {
      try {
        return this.nodeType == 8 && this.data.match(/snippet data-type=\"start\"/);
      } catch (e) {
        // Yay for not being allow to look at dom elements with external content, aka iframes
        return false;
      }
    });
    snippetComments.map(function() {
      
      var name = this.data.match(/snippet data-type=\"start\" data-name=\"(.*?)\"/)[1];
      
      snippets.names.push(name);
      
      snippets.snippets[name] = {
        comment:this,
        elements:function() {
          
          var snippetElements = [];
          var element = this.comment;
          while(element.nextSibling) {
            element = element.nextSibling
            if(element.nodeType == 8 && element.data.match(/snippet data-type=\"end\"/)) {
              break;
            }
            snippetElements.push(element);
          }
          
          return $(snippetElements);
        },
        update:function(newElements) {
          this.elements().remove();
          $(newElements).insertAfter(this.comment);
        }
      };
    });
    
    return snippets;
  };
  
}(window,jQuery));