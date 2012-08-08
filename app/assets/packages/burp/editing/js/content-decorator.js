(function($) {
  window.ContentDecorator = ContentDecorator;
  
  var instanceCounter = 0;
  var shortCircuit = false;

  function ContentDecorator(element, options) {
    this.element = $(element);
    this.converter = new Showdown.converter();
    this.parking = $('<div style="display: none;"></div>').appendTo('body');

    if (typeof(options) == 'object') {
      this.onUpdate = options['update'];
    }

    if (typeof(this.element.attr('id')) == 'undefined') {
      this.element.attr('id', '_ce_aid_' + (instanceCounter += 1));
    }

    this.id = this.element.attr('id');
    
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
  }

  $.extend(ContentDecorator.prototype, {
    
    getHtml: function() {
      return this.element.html();
    },
    getMarkdown: function() {
      return this.markdown;
    },
    setMarkdown: function(markdown) {
      if (this.markdown != markdown) {
        this.markdown = markdown;
        this.updateContent();

        if (this.onUpdate) {
          this.onUpdate();
        }
      }
    },
    updateContent: function() {
      this.parkImages();

      this.element.html(this.converter.makeHtml(this.markdown));
      $('#' + this.id + '>*').addClass('markdown').each(calculateHash)
      
      this.unparkImages();
    },
    parkImages: function() {
      var parking = this.parking;
      this.element.find('.movable').each(function() {
        parking.prepend(this);
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
    addRemoveZone: function(element) {
      $(element).droppable({
        hoverClass: 'delete-active',
        tolerance: "pointer",
        drop: function(event, ui) {
          if(ui.draggable.parents("#gallery").length == 0) {
            ui.draggable.remove();
            ui.draggable.data("removed",true);
          }
          clearDropBoxes();
        },
        over: function(event,ui) { 
          if(ui.draggable.parents("#gallery").length != 0) {
            $(this).removeClass('delete-active');
          }
        }
      });
    }
  });

  function initializeMovable(contentEditor, elements, createCallback) {
    if (!$(elements).hasClass('movable')) {
      
      $(elements).addClass('movable');
      
      $(elements).draggable({
        revert: true,
        revertDuration: 0,
        opacity: 0.6,
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
          
          var headerPosition = $('body > header').offset();
          
          contentEditor.element.find('.markdown').each(function() {
      
            var position = $(this).offset();
            var size = {width:$(this).outerWidth(),height:$(this).outerHeight()}
            position.left -= headerPosition.left;
            
            var element = $('<div class="dropbox"></div>');
            wrappers.push(element[0]);
      
            element.data("target-element",this);
      
            element.css(size);
            element.css(position);
            element.css({'position':'absolute'});
            element.appendTo('body');
          });
          
          wrappers = $(wrappers)
          wrappers.append('<div class="dropzone left" /><div class="dropzone center" /><div class="dropzone right" />');

          wrappers.find('.dropzone').droppable({
            hoverClass: 'active',
            tolerance: "pointer",
            over: function() { 
              $(this).parent().addClass('active'); 
              $(this).parent().data('active-child', this);
            },
            out: function() { 
              if ($(this).parent().data('active-child') == this) {
                $(this).parent().removeClass('active'); 
              }
            },
            drop: function(event, ui) {              
              
              if(!ui.draggable.data("removed")) {
                var className = $(this).removeClass('dropzone')[0].className;
                var img = createCallback(ui.draggable[0], className);

                initializeMovable(contentEditor, img, function(element, positionClass) { 
                  console.debug(element, positionClass)
                  $(element).removeClass('left center right');
                  $(element).addClass(positionClass);
                  return element;
                });

                var markdown = $(this).parent().data("target-element");
              
                insertMovable(img, markdown);
                clearDropBoxes();
              }
            }
          });
        },
        stop: function(event, ui) {
          clearDropBoxes();
        }
      });
    }
  }
  
  function clearDropBoxes() {
    $('body > .dropbox').remove();
  };

  function calculateHash() {
    $(this).attr('id', "hashed-" + MD5($(this)[0].outerHTML.toLowerCase().replace(/\W+/, '')));
  }

  function insertMovable(movable, before) {
    movable = $(movable);

    if (typeof(before) == 'undefined') {
      if ($('#' + movable.data('before')).length > 0) {
        $('#' + movable.data('before')).before(movable);
      } else if ($('#' + $(movable).data('after')).length > 0) {
        $('#' + movable.data('after')).after(movable);
      } else {
        console.debug("Cannot find home for image", movable);
      }
    } else {
      $(before).before(movable);
    }

    fixate(movable);
  }

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
})(jQuery);
