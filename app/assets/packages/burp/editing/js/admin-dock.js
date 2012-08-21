$(function($) {

  var originalBodyPadding = parseInt($('body').css('padding-bottom'));

  var dockElement = $('<div class="admin-dock"><div class="modules"></div></div>');
  var moduleElement = dockElement.find('.modules');
  var headerElement = $('<header class="dock-toolbar"><ul class="primary"><li class="title" html="Admin">Admin</li></ul><ul class="secondary"><li><a class="close"><i class="icon-remove close"></i></a></li></ul><div class="clearfix"></div></header>');
  var footerElement = $('<footer class="dock-toolbar"><ul class="primary"></ul><ul class="secondary"></ul><div class="clearfix"></div></footer>');

  dockElement.prepend(headerElement);
  dockElement.append(footerElement);

  dockElement.hide();
  headerElement.find('.close').click(function() {
    $.adminDock.hide();
  });

  $('body').append(dockElement);

  $.extend($, {
    adminDock: {
      addModule: function(modules) {
        setBodyPadding();
      },

      show: function(module, unhide) {
        showModule(module, unhide);
      },

      hide: function() {
        dockElement.hide();
        setBodyPadding();
      },

      toggle: function() {
        if ($.adminDock.visible()) {
          $.adminDock.hide();
        } else {
          $.adminDock.show();
        }
      },

      visible: function() {
        return dockElement.css('display') != 'none';
      },

      resize: function() {
        setBodyPadding();
      },

      title: function(title) {
        headerElement.find('.title').html(title);
      },

      footer: {
        addButton: function(options) {
          var element = $('<li><a></a></li>');
          var button = element.find('a');
          
          button.click(function(event) {
            event.preventDefault();
          });

          if (options['icon']) {
            button.append('<i class="icon-' + options['icon'] + '"></i>');
          }
          if (options['text']) {
            button.append('<label>' + options['text'] + '</label>');
          }
          if (options['click']) {
            button.click(options['click']);
          }
          if (options['showModule']) {
            moduleElement.append(options['showModule']);
            $(options['showModule']).data('dock-button', button);

            button.click(function() {
              footerElement.find('a').removeClass('active');
              $(this).addClass('active');
              showModule(options['showModule'])

              if (options['show']) {
                options['show']();
              }

              $.adminDock.resize();
            });
          }

          $.adminDock.footer.addElement(element, options);
        },

        buttons: function() {
          return footerElement.find('a');
        },

        addSelector: function(options) {
          var width = options['width'] || 200;
          var element = $('<li class="toolbar-selector"><a href="javascript: void 0;"></a></li>');
          var button = element.find('a');

          button.css('width', '' + width + 'px');
          button.append("<i class='icon-sort'></i>");
          button.append("<label>" + options['default'] + "</label>");
          button.click(function() {
            if ($(this).closest('li').find('ul').length > 0) {
              $(this).closest('li').find('ul').remove();
            } else {
              var selector = $(this).closest('li').append('<ul></ul>').find('ul');
              $.each(options['options'], function() {
                selector.append("<li style='width: " + width + "px;'>" + this + "</li>");
              });
              selector.delegate('li', 'click', function(event) {
                var value = $(this).html();
                options['change'](value);
                button.find('label').html(value);
                selector.remove();
              });
            }
          });

          $.adminDock.footer.addElement(element, options);
        },

        // $.adminDock.footer.addSelector({
        //   options: ['main', 'sidebar', 'footer'],
        //   default: 'sidebar',
        //   change: function(option) {
        //     alert("Switching to " + option);
        //   }
        // });

        addElement: function(element, options) {
          if (options['secondary']) {
            console.debug("Adding to secondary");
            footerElement.find('.secondary').append(element);
          } else {
            console.debug("Adding to primary")
            footerElement.find('.primary').append(element);
          }
        }

      }
    }
  });

  function addModule(module) {
    moduleElement.append(module);
  }

  var activeModuleButton = null;
  function showModule(module, unhide) {
    if (typeof(unhide) == 'undefined' || unhide == true) {
      dockElement.show();
    }

    if (typeof(module) != 'undefined') {
      if (activeModuleButton) {
        activeModuleButton.removeClass('active');
        activeModuleButton = null;
      }

      dockElement.find('.modules>*').hide();
      $(module).show();
      if ($(module).data('dock-button')) {
        $(module).data('dock-button').addClass('active');
        activeModuleButton = $(module).data('dock-button')
      }
    }

    setBodyPadding();
  }

  function setBodyPadding() {
    var height = $.adminDock.visible() ? dockElement.height() : 0;
    $('body').css('padding-bottom', (originalBodyPadding + height) + 'px');
  }

});
