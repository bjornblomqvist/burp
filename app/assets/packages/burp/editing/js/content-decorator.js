/*global
  marked markdown2Html
*/
(function($) {
  
  var javascript_warning_has_been_shown = false;
  
  marked.setOptions({
    gfm: true,
    pedantic: false,
    sanitize: false
  });
  
  function unescapeJavascript(script) {
    return script.replace(/&quot;/g,'"').replace(/&#39;/g,"'").replace(/&lt;/g,"<").replace(/&gt;/g,"<");
  }
  
  function ContentDecorator(element, options) {
    this.element = $(element);

    if (typeof(options) === 'object') {
      this.onUpdate = options['update'];
    }
    
    this.init();
  }
  
  window.ContentDecorator = ContentDecorator;
  
  function clearDropBoxes() {
    $('body > .dropbox').remove();
  }

  function initializeMovable(contentEditor, elements, createCallback) {
    if (!$(elements).hasClass('movable')) {
      
      $(elements).addClass('movable');
      
      $(elements).draggable({
        cursor: 'move',
        revert: true,
        revertDuration: 0,
        opacity: 0.6,
        distance: 5,
        zIndex: 900,
        appendTo: "body",
        helper: 'clone',
        refreshPositions: true,
        drag: function(event, ui) {
          ui.position.left = event.clientX;
          ui.position.top = event.clientY;
          ui.position.left -= (ui.helper.width()/2.0);
          ui.position.top -= (ui.helper.height()/2.0);
        },
        start: function(event, ui) {
          
          var wrappers = [];
          
          var bodyOffset =  $('body').offset();
          var bodyPosition = $('body').css('position');
          
          contentEditor.element.find('> h1,> h2,> h3,> h4,> h5,> p,> img,> blockquote,> ul,> ol').each(function() {
      
            var position = $(this).offset();
            var size = {width:$(this).outerWidth(),height:$(this).outerHeight()};
            if(bodyPosition !== 'static') {
              position.left -= bodyOffset.left;      
              position.top -= bodyOffset.top;
            }
            
            var element = $('<div class="dropbox"></div>');
            wrappers.push(element[0]);
      
            element.data("target-element",this);
      
            element.css(size);
            element.css(position);
            element.css({'position':'absolute'});
            element.appendTo('body');
          });
          
          // Add bottom dropbox
          if(wrappers.length > 0) {
            var lastElement = $(wrappers[wrappers.length-1]);
            var element = lastElement.clone();
            var newTop = 20 + parseInt(element.css("top").replace("px",''),10) + parseInt(element.css("height").replace("px",''),10);
            
            element.addClass("bottom-dropbox");
            
            element.css("top",newTop);
            element.css("height",50);
            wrappers.push(element[0]);
            element.appendTo('body');
          }
          
          // Add empty area dropbox
          if(wrappers.length === 0) {
            var position = $(contentEditor.element).offset();
            var size = {width:$(contentEditor.element).outerWidth(),height:$(contentEditor.element).outerHeight()};
            if(navigator.userAgent.match(/Firefox|Safari/)) {
              position.left = $(contentEditor.element)[0].offsetLeft;
            } else {
              position.left -= $(contentEditor.element).offsetParent().offset().left;
            }
            
            if(size.height < 20) {
              size.height = 50;
            }
            
            if(size.width < 10) {
              size.width = 100;
            }
            
            var element2 = $('<div class="dropbox"></div>');
            wrappers.push(element2[0]);
      
            element2.addClass("bottom-dropbox");
      
            element2.css(size);
            element2.css(position);
            element2.css({'position':'absolute'});
            element2.appendTo('body');
          }
          
          wrappers = $(wrappers);
          wrappers.append('<div class="dropzone left" /><div class="dropzone center" /><div class="dropzone right" />');

          wrappers.find('.dropzone').droppable({
            hoverClass: 'active',
            tolerance: "pointer",
            over: function() { 
              $(this).parent().addClass('active'); 
              $(this).parent().data('active-child', this);
            },
            out: function() { 
              if ($(this).parent().data('active-child') === this) {
                $(this).parent().removeClass('active'); 
              }
            },
            drop: function(event, ui) {              
              
              if(!ui.draggable.data("removed")) {
                var className = $(this).removeClass('dropzone')[0].className;
                var img = createCallback(ui.draggable[0], className);

                initializeMovable(contentEditor, img, function(element, positionClass) { 
                  $(element).removeClass('left center right');
                  $(element).addClass(positionClass);
                  return element;
                });

                var markdown = $(this).parent().data("target-element");
                
                var src = $(img).attr('src');
                if(src.match(/\/files\/small\//)) {
                  $(img).attr('src',src.replace(/\/files\/small\//,'/files/large/'));
                }
                
                if($(this).parent().is(".bottom-dropbox")) {
                  $(contentEditor.element).append(img);
                } else if(img !== markdown) {
                  $(img).insertBefore(markdown);
                }
                clearDropBoxes();
              }
              
              $("#gallery").removeClass('delete-active');
              $(document).trigger("image-drop-done.burp");
            }
          });
          
          // Show remove zone
          if($(this).parents("#gallery").length === 0) {
            $("#gallery").addClass('delete-active');
          }
        },
        
        stop: function(event, ui) {
          clearDropBoxes();
          
          $("#gallery").removeClass('delete-active');
        }
      });
    }
  }
  
  function removeDraggable( element ) {
    element.find( ".movable" ).draggable( "destroy" );
  }
  
  function removeRemoveZone() {
    $('.remove-zone').removeClass('remove-zone').droppable( "destroy" );
  }
  
  $.extend(ContentDecorator.prototype, {
    
    init: function() {
      var contentEditor = this;
      $(this.element).find("> .movable").each(function() {
        $(this).removeClass('movable');
        initializeMovable(contentEditor, this, function(element, positionClass) { 
          $(element).removeClass('left center right');
          $(element).addClass(positionClass);
          return element;
        });
      });
    },
    
    
    cleanup: function() {
      removeDraggable(this.element);
      removeRemoveZone();
    },
    
    getHtml: function() {
      
      var html = this.element.clone();
      html.find('script[type="text/dont-run-javascript"]').each(function() {
        $(this).attr("type",'text/javascript');
      });
      
      return html.find('.movable').removeClass('ui-draggable ui-droppable').end().html();
    },
    
    getMarkdown: function() {
      return this.markdown;
    },
    
    setMarkdown: function(markdown) {
      if (this.markdown !== markdown) {
        this.markdown = markdown;
        this.updateContent();

        if (this.onUpdate) {
          this.onUpdate();
        }
      }
    },
    
    updateContent: function() {
      var html = window.markdown2Html(this.markdown);
      
      if(this.lastHtml === html) {
        return;
      }
      this.lastHtml = html;
      
      var children = $(html);
      
      // Fix script escaping of text in script elements
      children.each(function() {
        if($(this).is("script")) {
          $(this).text(unescapeJavascript($(this).text()));
          $(this).attr('type','text/dont-run-javascript');
        } else {
          $(this).find('script').each(function() {
            $(this).text(unescapeJavascript($(this).text()));
            $(this).attr('type','text/dont-run-javascript');
          });
        }
      });
      
      var tempElement = $('<div></div>');
      tempElement.append(children);
      
      if(tempElement.find("script").length > 0 && !javascript_warning_has_been_shown) {
        $.gritter.add({
          title: 'WARNING!',
          text: ' Javascript found! The javascript will not be previewed but it will be saved.<br><br>Save and reload to test the javascript.',
          time: 20000
        });
        
        javascript_warning_has_been_shown = true;
      }
      
      // Fixes so that we don't reload images on each update
      var _this = this;
      tempElement.find('img').each(function() {
        var element = _this.element.find('img[src="'+$(this).attr('src')+'"]');
        if(element.length === 1) {
          if(element[0].outerHTML === this.outerHTML) {
            $(this).replaceWith(element);
          }
        }
      });
      
      this.element.html("");
      this.element.append(tempElement.children());
      
      setTimeout(function() {
        initializeMovable(_this, _this.element.find('> img'), function(element, positionClass) { 
          $(element).removeClass('left center right');
          $(element).addClass(positionClass);
          return element;
        });
      },10);
    },
    
    makeDroppable: function(elements, createCallback) {
      initializeMovable(this, elements, createCallback);
    },
    
    removeDroppable: function(elements) {
      $(elements).draggable( 'destroy' );
    },
    
    addRemoveZone: function(element) {
      $(element).addClass('remove-zone');
      $(element).droppable({
        hoverClass: 'remove-hover',
        tolerance: "pointer",
        drop: function(event, ui) {
          if(ui.draggable.parents("#gallery").length === 0) {
            setTimeout(function() {
              // jquery-ui breaks if we remove the element during the callback
              ui.draggable.remove();
            },0);
            ui.draggable.data("removed",true);
          }
          $("#gallery").removeClass('delete-active');
          clearDropBoxes();
        }
      });
    }
  });

}(jQuery));

