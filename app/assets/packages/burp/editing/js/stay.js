/*global
  MD5
*/
$(function() {
  
  $.fn.md5Hash = function() {
    
    $(this).each(function() {
      var html = $(this).html();
      if(!$(this).data('md5-hash') || $(this).data('md5-hash-html') !== html) {
        $(this).data('md5-hash-html',html);
        $(this).data('md5-hash',MD5(html));
      }
    });
    
    return $(this).data('md5-hash');
  };
  
  $.fn.park = function(selector) {
    
    $(this).each(function() {
      
      var tempLocation = $(this).data('park-temp-element') || $('<div></div>');
      $(this).data('park-temp-element',tempLocation);
      
      $(this).find(selector).each(function() {
        
        var above = ['top'];
        var below = [];
        
        $($(this).prevAll("p,ul,ol,h1,h2,h3,h4,h5").get().reverse()).each(function() {
          above.push($(this).md5Hash());
        });
        
        $(this).nextAll("p,ul,ol,h1,h2,h3,h4,h5").each(function() {
          below.push($(this).md5Hash());
        });
        
        if(above.length == 0) {
          above.push('top');
        }
        
        if(below.length == 0) {
          below.push('bottom');
        }
        
        $(this).data('hashes-above',above.reverse().slice(0,3).reverse());
        $(this).data('hashes-below',below.slice(0,3));
        
        tempLocation.append(this);
      });
    });
  };
  
  var multiplyer = 0.62;
  
  function matchBelow(hashes,location,below) {
    hashes = hashes.slice(location);
    
    var currentValue = 1;
    var totalMatchValue = 0;
    
    $.each(below,function(index,value) {
      if(value === hashes[index]) {
        totalMatchValue += currentValue;
      }
      
      currentValue = currentValue * multiplyer;
    });
    
    return totalMatchValue;
  }
  
  function matchAbove(hashes,location,above) {
    hashes = hashes.slice(0,location).reverse();
    above = above.slice(0).reverse();
    
    return matchBelow(hashes,0,above);
  }
  
  $.fn.unpark = function() {
    console.debug('unpark');
    
    $(this).each(function() {
      
      var hashes = [];
      var elements = [];
      var container = this;

      $(this).find("p,ul,ol,h1,h2,h3,h4,h5").each(function() {
        var hash = $(this).md5Hash();
        elements.push({hash:hash,element:this});
        hashes.push(hash);
      });
      
      hashes.unshift('top');
      elements.unshift('top');
      hashes.push('bottom');
      elements.push('bottom');

      $($(this).data('park-temp-element') || []).first().children().each(function() {
        
        console.debug(" ");
        console.debug(this);
        console.debug(hashes);
        console.debug($(this).data('hashes-above'),$(this).data('hashes-below'))
        
        var best = {match:0};
        var element = this;
        
        $.each(elements,function(index,value) {
          var a = matchAbove(hashes,index,$(element).data('hashes-above') || []);
          var b = matchBelow(hashes,index,$(element).data('hashes-below') || []);
          var match = a + b;
          
          
          if(match > best.match && match >= 1) {
            if(value === 'top' || value === "bottom") {
              best = {match:match,element:value};
            } else {
              best = {match:match,element:value.element};
            }
          }
          
          console.debug({above:a,below:b,result:match},best);
        });
        
        if(best.element === 'top') {
          $(container).prepend(element);
        } else if(best.element === "bottom") {
          $(container).append(element);
        } else if(best.element) {
          $(element).insertBefore(best.element);
        }
      });
      
      // Remove any left over element
      $($(this).data('park-temp-element') || []).first().children().remove();  
    });    
  };
  
  
});