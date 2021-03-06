/*global
  markdown2Html snippets
*/
(function($) {
  
  var javascript_warning_has_been_shown = false;
  
  function ContentDecorator(snippetName, options) {
    this.snippetName = snippetName;
    this.callbacks = {
      remove: function(element) {
        console.debug("remove", element);
      },
      insertBefore: function(beforeElement, element) {
        console.debug('insertBefore', beforeElement, element);
      },
      append: function(snippetName, element) {
        console.debug('append', snippetName, element);
      },
      setPositionClass: function(className, element) {
        console.debug('setPositionClass', className, element);
      }
    };

    if (typeof(options) === 'object') {
      this.onUpdate = options['update'];
    }
  }
  
  window.ContentDecorator = ContentDecorator;
  
  function clearDropBoxes() {
    $('body > .dropbox').remove();
  }

  function initializeMovable(contentEditor, elements, cloneImage) {
    if (!$(elements).hasClass('movable')) {
      
      $(elements).addClass('movable');
      if(typeof(cloneImage) === "undefined") {
        cloneImage = false;
      }
      
      $(elements).draggable({
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
          
          var snippetElements = snippets().snippets[contentEditor.snippetName].elements();
          $(snippetElements).filter('h1, h2, h3, h4, h5, p, img, blockquote, ul, ol').each(function() {
      
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
            
            var comment = snippets().snippets.footer.comment;
            var aElement = comment.previousElementSibling || comment.nextElementSibling || comment.parentElement;
            var position = $(aElement).offset();
            var size = {width:$(aElement).outerWidth(),height:$(aElement).outerHeight()};
            if(navigator.userAgent.match(/Firefox|Safari/)) {
              position.left = $(aElement)[0].offsetLeft;
            } else {
              position.left -= $(aElement).offsetParent().offset().left;
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
                
                var className = $(this).removeClass('dropzone ui-droppable')[0].className;
                var imageElement = ui.draggable[0];
                var markdown = $(this).parent().data("target-element");
                
                $(imageElement).removeClass('left center right');
                $(imageElement).addClass(className);
                
                if(markdown === imageElement) {
                  contentEditor.callbacks.setPositionClass(className, $(imageElement));
                } else {

                  // var src = $(img).attr('src');
                  // if(src.match(/\/files\/small\//)) {
                  //   $(img).attr('src', src.replace(/\/files\/small\//,'/files/large/'));
                  // }
                  
                  if(cloneImage) {
                    imageElement = $(imageElement).clone();
                  }

                  if($(this).parent().is(".bottom-dropbox")) {
                    snippets().snippets[contentEditor.snippetName].append($(imageElement));
                    contentEditor.callbacks.append(contentEditor.snippetName, $(imageElement));
                  } else {
                    $(imageElement).insertBefore(markdown);
                    contentEditor.callbacks.insertBefore($(markdown), $(imageElement));
                  }
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
  
  $.extend(ContentDecorator.prototype, {
    
    setSnippetName: function(snippetName) {
      this.snippetName = snippetName;
    },
    
    setCallbacks: function(callbacks) {
      this.callbacks = callbacks;
    },
    
    //       // Fixes so that we don't reload images on each update
    //       var _this = this;
    //       tempElement.find('img').each(function() {
    //         var element = _this.element.find('img[src="'+$(this).attr('src')+'"]');
    //         if(element.length === 1) {
    //           if(element[0].outerHTML === this.outerHTML) {
    //             $(this).replaceWith(element);
    //           }
    //         }
    //       });
    //     },
    
    makeDroppable: function(elements, cloneImage) {
      var contentEditor = this;
      $(elements).one('mouseover', function() {
        initializeMovable(contentEditor, this, cloneImage);
      });
    },
    
    addRemoveZone: function(element) {
      var contentEditor = this;
      $(element).addClass('remove-zone');
      $(element).droppable({
        hoverClass: 'remove-hover',
        tolerance: "pointer",
        drop: function(event, ui) {
          if(ui.draggable.parents("#gallery").length === 0) {
            setTimeout(function() {
              // jquery-ui breaks if we remove the element during the callback
              contentEditor.callbacks.remove(ui.draggable);
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

