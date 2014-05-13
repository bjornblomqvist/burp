(function(window,jQuery) {
  
  var $ = jQuery;
  
  function getData(string) {
    var data = {};
    
    $.each(string.match(/data-(.*?)="(.*?)"/g) || [], function(index, value) {
      var match = value.match(/data-(.*?)="(.*?)"/);
      data[match[1]] = match[2];
    });
    
    return data;
  }
  
  window.snippets = function() {
    
    var snippets = {names:[],snippets:{}};
    
    var snippetComments = $("*:not(iframe)").contents().filter(function() {
      try {
        return this.nodeType === 8 && this.data.match(/snippet data-type=\"start\"/);
      } catch (e) {
        // Yay for not being allow to look at dom elements with external content, aka iframes
        return false;
      }
    });
    
    snippetComments.each(function() {
      
      var data = getData(this.data);
      
      snippets.names.push(data['name']);
      
      snippets.snippets[data['name']] = {
        pageId:data['page-id'],
        data:data,
        comment:this,
        elements:function() {
          
          var snippetElements = [];
          var element = this.comment;
          while(element.nextSibling) {
            element = element.nextSibling;
            if(element.nodeType === 8 && element.data.match(/snippet data-type=\"end\"/)) {
              break;
            }
            snippetElements.push(element);
          }
          
          return $(snippetElements);
        },
        update:function(newElements) {
          this.elements().remove();
          $(newElements).insertAfter(this.comment);
        },
        prepend:function(newElements) {
          $(newElements).insertAfter(this.comment);
        },
        append:function(newElements) {
          $(newElements).insertAfter(this.elements().last());
        }
        
      };
    });
    
    return snippets;
  };
  
}(window,jQuery));