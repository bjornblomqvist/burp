$(function() {
  
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
 
  $('body.burp-page-index .container > section.group li.link, body.burp-page-index .container > section.group section.group').draggable({
    handle: 'h2, a',
    opacity: 0.5,
    helper: 'clone',
    revert: 250,
    distance: 10,
    start: function(event, ui) {
      $(event.target).addClass("draging");
      rects = getRects($("body.burp-page-index .container > section.group"),"section.group, li.link");
    },
    stop: function(event, ui) {
      rects = [];
      $(event.target).removeClass("draging");
    },
    drag: function(event, ui) {
      var rect = currentRect(event);
      
      // $.debug("drag",rect,event,ui);
      
      if(rect) {
        if(rect.element === event.target) {
          // $.debug("above self");
        } else if(rect.element === ui.helper[0]) {
          // $.debug("above helper");
        } else if($(event.target).has(rect.element).length > 0) {
           // $.debug("cant put parent into child");
        } else {
          if(rect.withinTopHalf(event)) {
            
            $(event.target).closest("li.child").insertBefore($(rect.element).closest("li.child"));
            rects = getRects($("body.burp-page-index .container > section.group"),"section.group, li.link");
            // $.debug(rect.element,"top half");
          } else if(rect.withinBottomHalf(event)) {
            $(event.target).closest("li.child").insertAfter($(rect.element).closest("li.child"));
            rects = getRects($("body.burp-page-index .container > section.group"),"section.group, li.link");
            // $.debug(rect.element,"bottom half");
          }
        }
      }
      

    }
  });
  
});