/*global
  Showdown MD5
*/
(function($) {
  
  var instanceCounter = 0;

  function ContentDecorator(element, options) {
    this.element = $(element);
    this.converter = new Showdown.converter();
    this.parking = $('<div style="display: none;"></div>').appendTo('body');

    if (typeof(options) === 'object') {
      this.onUpdate = options['update'];
    }

    if (typeof(this.element.attr('id')) === 'undefined') {
      this.element.attr('id', '_ce_aid_' + (instanceCounter += 1));
    }

    this.id = this.element.attr('id');
    
    this.initImages();
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
        $('#' + movable.data('after')).after(movable);
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
          
          var headerPosition = $('body > header').offset();
          
          contentEditor.element.find('.markdown').each(function() {
      
            var position = $(this).offset();
            var size = {width:$(this).outerWidth(),height:$(this).outerHeight()};
            position.left -= headerPosition.left;
            
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

  function calculateHash() {
    $(this).attr('id', "hashed-" + MD5($(this)[0].outerHTML.toLowerCase().replace(/\W+/, '')));
  }
  
  $.extend(ContentDecorator.prototype, {
    
    initImages: function() {
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
    
    getHtml: function() {
      return this.element.html();
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
      this.element.children().remove().end().append(tempElement.children());
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
        hoverClass: 'remove-hover',
        tolerance: "pointer",
        drop: function(event, ui) {
          if(ui.draggable.parents("#gallery").length === 0) {
            ui.draggable.remove();
            ui.draggable.data("removed",true);
          }
          $("#gallery").removeClass('delete-active');
          clearDropBoxes();
        }
      });
    }
  });
  
  /* Gallery navigation */
  
  function updateButtonStates(positonChange) {
    positonChange = positonChange || 0;
    
    var galleryWidth = $('#gallery').width();
    var nextButtonWidth = $('#gallery .next').width();
    var prevButtonWidth = $('#gallery .prev').width();
        
    var canScrollLeft = false;
    var canScrollRight = false;
      
    $('#gallery .images img').each(function() {
      if(($(this).offset().left + positonChange) < prevButtonWidth) {
        canScrollLeft = true;
      }
      
      if(($(this).offset().left + positonChange) + $(this).width() > galleryWidth - nextButtonWidth) {
        canScrollRight = true;
      }
    });
    
    $('#gallery .prev').removeClass("enabled disabled").addClass(canScrollLeft ? "enabled" : "disabled");
    $('#gallery .next').removeClass("enabled disabled").addClass(canScrollRight ? "enabled" : "disabled");
  }
  
  $(document).on('refresh.gallery',"#gallery",function() {
    updateButtonStates();
  });
  
  $(document).on('reset.gallery',"#gallery",function() {
    var toLeft = $('#gallery .images').css("left").replace(/px/,'') * -1;
    $('#gallery .images').stop().animate({left:"+="+toLeft});
    updateButtonStates(toLeft);
  });
  
  $(document).on("click","#gallery .prev.enabled",function() {
    var galleryWidth = $('#gallery').width();
    var nextButtonWidth = $('#gallery .next').width();
    var prevButtonWidth = $('#gallery .prev').width();
    
    var scrollWidth = galleryWidth - nextButtonWidth - prevButtonWidth;
    
    //  Find the first fully visible element
    var firstElementWithinScrollWidth;
    $('#gallery .images img').each(function() {
      if($(this).offset().left > prevButtonWidth - scrollWidth) {
        firstElementWithinScrollWidth = this;
        return false;
      }
    });
    
    var scrollBy = (-$(firstElementWithinScrollWidth).offset().left) + prevButtonWidth;
    $('#gallery .images').stop().animate({left:"+="+scrollBy});
    updateButtonStates(scrollBy);
  });
  
  $(document).on("click","#gallery .next.enabled",function() {
    var galleryWidth = $('#gallery').width();
    var nextButtonWidth = $('#gallery .next').width();
    var prevButtonWidth = $('#gallery .prev').width();
    
    // Find the last fully visible element
    var lastVisibleElement;
    $('#gallery .images img').each(function() {
      if($(this).offset().left + $(this).width() < galleryWidth - nextButtonWidth) {
        lastVisibleElement = this;
      }
    });
        
    var scrollBy = $(lastVisibleElement).offset().left + $(lastVisibleElement).width() + (parseFloat($($('.images img').get(2)).css('marginLeft').replace(/px/,'')) * 2) - prevButtonWidth;
    $('#gallery .images').stop().animate({left:"-="+scrollBy});
    updateButtonStates(-scrollBy);
  });
}(jQuery));
