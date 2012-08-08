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
      contentEditor = this;
      $(element).droppable({
        hoverClass: 'delete-active',
        drop: function(event, ui) {
          if(ui.draggable.parents("#gallery").length == 0) {
            ui.draggable.remove();
          }
          shortCircuit = true;
          cleanupDropzones(contentEditor);

          setTimeout(function() { shortCircuit = false; }, 1);
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
        start: function(event, ui) {
          
          var wrappers = contentEditor.element.find('.markdown').wrap('<div class="dropbox"></div>').parent();
          wrappers.append('<div class="dropzone left" /><div class="dropzone center" /><div class="dropzone right" />');

          wrappers.find('.dropzone').droppable({
            hoverClass: 'active',
            tolerance: "pointer",
            over: function() { 
              console.debug("over", this); 
              $(this).parent().addClass('active'); 
              $(this).parent().data('active-child', this);
            },
            out: function() { 
              console.debug("out", this); 
              if ($(this).parent().data('active-child') == this) {
                $(this).parent().removeClass('active'); 
              }
            },
            drop: function(event, ui) {
              if (shortCircuit) return;

              var className = $(this).removeClass('dropzone')[0].className;
              var img = createCallback(ui.draggable[0], className);

              initializeMovable(contentEditor, img, function(element, positionClass) { 
                $(element).removeClass('left center right');
                console.debug(element, positionClass)
                $(element).addClass(positionClass);
                return element;
              });

              var markdown = $(this).siblings('.markdown');
              wrappers.each(function() {
                $(this).replaceWith($(this).find('.markdown'));
              });

              insertMovable(img, markdown);
            }
          });
        },
        stop: function(event, ui) {
          cleanupDropzones(contentEditor);
        }
      });
    }
  }

  function cleanupDropzones(contentEditor) {
    contentEditor.element.find('.dropbox').each(function() {
      $(this).replaceWith($(this).find('.markdown'));
    });
  }

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
