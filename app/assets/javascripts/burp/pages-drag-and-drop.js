/*global
  
*/

$(function() {
  
  function serializeGroup(element) {
    if($(element).is("section.group")) {
      return {
        name:($(element).find("> .group-name").text()),
        children:$(element).find("> ul.children > li").map(function() {
          if($(this).is(".link")) {
            var a = $(this).find('a');
            return {name:a.text(), url:(a.attr("orginial-url") || a.attr("href"))};
          } else if($(this).is(".group")) {
            return serializeGroup($(this).find('> section.group'));
          }
        }).toArray()
      };
    }
  }
  
  var rects = [];
  
  function within(event) {
    var x = event.pageX;
    var y = event.pageY;
    return (x >= this.left && x <= this.right) && (y >= this.top && y <= this.bottom);
  }
  
  function withinTopHalf(event) {
    var x = event.pageX;
    var y = event.pageY;
    return (x >= this.left && x <= this.right) && (y >= this.top && y <= (this.top + (this.bottom - this.top) / 2));
  }
  
  function withinBottomHalf(event) {
    var x = event.pageX;
    var y = event.pageY;
    return (x >= this.left && x <= this.right) && (y > (this.top + (this.bottom - this.top) / 2) && y <= this.bottom);
  }
  
  function getRects(rootElement,dropableSelector) {
    
    var rects = [];
    
    $(rootElement).find(dropableSelector).each(function() {    
      
      if($(this).closest('.ui-draggable-dragging').length > 0) {
        return;
      }
      
      var rect = $(this).offset();
      
      rect.within = within;
      rect.withinBottomHalf = withinBottomHalf;
      rect.withinTopHalf = withinTopHalf;
      
      rect.bottom = rect.top + $(this).height();
      rect.right = rect.left + $(this).width();
      rect.parentCount = $(this).parentsUntil(rootElement).length;
      rect.element = this;
      
      rects.push(rect);
    });
    
    return rects;
  }
  
  function currentRect(x,y) {
    var rect;
    
    $.each(rects,function() {
      if(this.within(x,y)) {
        if(!rect) {
          rect = this;
        } else if(rect.parentCount < this.parentCount) {
          rect = this;
        }
      }
    });
    
    return rect;
  }
 
  function initDND(elements) {
 
    elements
      .prepend('<span class="drag-handel">Drag</span>')
      .draggable({
      handle: '.drag-handel',
      opacity: 0.5,
      helper: 'clone',
      distance: 10,
      start: function(event, ui) {
        $(event.target).addClass("draging");
        rects = getRects($(".dnd-editable-menu > section.group"),"li.child, ul.children");
      },
      stop: function(event, ui) {
        rects = [];
        $(event.target).removeClass("draging");

        // Need to wait a bit as the ui-helper is still in the dom
        setTimeout(function() {
          var menu = serializeGroup($(".dnd-editable-menu > section.group").first());
        
          $.put("./",{menu:JSON.stringify(menu)},function() {
            $.get("./edit?no_layout=true",function(data) {
              var menuHtml = $("<div></div>").append(data).find('.dnd-editable-menu').first().html()
              $('.dnd-editable-menu').first().html(menuHtml);
              initDND($('.dnd-editable-menu').first().find('> section.group li.link, > section.group li.group'));
            });
          });
        },10);
      },
      drag: function(event, ui) {
        var rect = currentRect(event);
      
        if(rect) {
        
          var x = event.pageX;
        
          if(rect.element === event.target) {
          
            // Add to above group if enough to the right
            if($(rect.element).is('.link') && $(rect.element).prev('.group') && rect.left + 50 < x) {
              $(event.target).closest("li.child").prependTo($(rect.element).prev().find('> section.group > ul.children'));
              rects = getRects($(".dnd-editable-menu > section.group"),"li.child, ul.children");
            } else {
              return;
              // Cant drop on self
            }  
          } else if(rect.element === ui.helper[0]) {
            // Cant drop ui helper
            return;
          } else if($(event.target).has(rect.element).length > 0) {
            // Cant drop on a child of self
            return;
          } else if($(rect.element).is("ul.children")) {
            // Can drop on an empty list
            $(event.target).closest("li.child").appendTo(rect.element);
            rects = getRects($(".dnd-editable-menu > section.group"),"li.child, ul.children");
          } else if($(rect.element).is("li.group")) {
            // Can drop on an empty list of a group
            if(rect.left + 50 < x) {
              // Add as child
              $(event.target).closest("li.child").prependTo($(rect.element).find('> section.group > ul.children'));
              rects = getRects($(".dnd-editable-menu > section.group"),"li.child, ul.children");
            } else {
              if(rect.withinTopHalf(event)) {
                $(event.target).closest("li.child").insertBefore($(rect.element).closest("li.child"));
                rects = getRects($(".dnd-editable-menu > section.group"),"li.child, ul.children");
              } else if(rect.withinBottomHalf(event)) {
                $(event.target).closest("li.child").insertAfter($(rect.element).closest("li.child"));
                rects = getRects($(".dnd-editable-menu > section.group"),"li.child, ul.children");
              }
            }
        
          } else {
            if(rect.withinTopHalf(event)) {
              $(event.target).closest("li.child").insertBefore($(rect.element).closest("li.child"));
              rects = getRects($(".dnd-editable-menu > section.group"),"li.child, ul.children");
            } else if(rect.withinBottomHalf(event)) {
              $(event.target).closest("li.child").insertAfter($(rect.element).closest("li.child"));
              rects = getRects($(".dnd-editable-menu > section.group"),"li.child, ul.children");
            }
          }
        }
      

      }
    });
  }
  
  initDND($('.dnd-editable-menu > section.group li.link, .dnd-editable-menu > section.group li.group'));
  
});