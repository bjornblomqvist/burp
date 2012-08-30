/*global
  Showdown MD5
*/
(function($) {
  
  function ContentDecorator(element, options) {
    this.element = $(element);
    this.converter = new Showdown.converter();
    this.parking = $('<div style="display: none;"></div>');

    if (typeof(options) === 'object') {
      this.onUpdate = options['update'];
    }
    
    this.init();
  }
  
  window.ContentDecorator = ContentDecorator;

  function fixate(movable) {
    movable = $(movable);
    var before = movable.nextAll('.markdown')[0];
    if (before) {
      movable.data('before', before.id);
    }
    
    var after = movable.prevAll('.markdown')[0];
    if (after) {
      movable.data('after', after.id);
    }
  }

  function insertMovable(movable, before) {
    movable = $(movable);

    if (typeof(before) === 'undefined') {
      if ($('#' + movable.data('before')).length > 0) {
        $('#' + movable.data('before')).before(movable);
      } else if ($('#' + $(movable).data('after')).length > 0) {
        if($('#' + movable.data('after')).next('.movable').length > 0) {
          $('#' + movable.data('after')).nextAll('.movable').last().after(movable);
        } else {
          $('#' + movable.data('after')).after(movable);
        }
      } else {
        console.debug("Cannot find home for image", movable);
      }
    } else {
      $(before).before(movable);
    }

    fixate(movable);
  }
  
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
          
          
          
          contentEditor.element.find('.markdown').each(function() {
      
            var position = $(this).offset();
            var size = {width:$(this).outerWidth(),height:$(this).outerHeight()};
            position.left -= $(this).offsetParent().offset().left;
            
            var element = $('<div class="dropbox"></div>');
            wrappers.push(element[0]);
      
            element.data("target-element",this);
      
            element.css(size);
            element.css(position);
            element.css({'position':'absolute'});
            element.appendTo('body');
          });
          
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
                  console.debug(element, positionClass);
                  $(element).removeClass('left center right');
                  $(element).addClass(positionClass);
                  return element;
                });

                var markdown = $(this).parent().data("target-element");
              
                insertMovable(img, markdown);
                clearDropBoxes();
              }
              
              $("#gallery").removeClass('delete-active');
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

  function calculateHash() {
    $(this).attr('id', "hashed-" + MD5($(this)[0].outerHTML.toLowerCase().replace(/\W+/, '')));
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
        fixate(this);
      });
    },
    
    
    cleanup: function() {
      removeDraggable(this.element);
      removeRemoveZone();
    },
    
    getHtml: function() {
      return this.element.clone().find('.movable').removeClass('ui-draggable ui-droppable').end().html();
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
      var html = this.converter.makeHtml(this.markdown).replace(/\s+/g,' ');
      if(this.lastHtml === html) {
        return;
      }
      this.lastHtml = html;
      
      var tempElement = $('<div></div>');
      tempElement.html(html);
      tempElement.children().addClass('markdown').each(calculateHash);
      
      var _this = this;
      tempElement.find('img').each(function() {
        var element = _this.element.find('img[src="'+$(this).attr('src')+'"]');
        if(element.length === 1) {
          if(element[0].outerHTML === this.outerHTML) {
            $(this).replaceWith(element);
          }
        }
      });
      
      this.parkImages();
      this.element.html("");
      this.element.append(tempElement.children());
      this.unparkImages();
    },
    
    parkImages: function() {
      var parking = this.parking;
      this.element.find('.movable').each(function() {
        parking.append(this);
      });
    },
    
    unparkImages: function() {
      this.parking.find('.movable').each(function() {
        insertMovable(this);
      });
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

