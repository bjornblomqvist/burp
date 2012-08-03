$(function() {
  

  var elements = $('<div style="display: none;">\
    <div id="gallery" style="display: none;">\
      <ul class="images">\
      </ul>\
      <i class="prev icon-large icon-caret-left"></i>\
      <i class="next icon-large icon-caret-right"></i>\
    </div>\
    <div id="myContentEditor" style="display: none;">\
      <textarea id="code" style="width: 100%; height: 300px;">\
      </textarea>\
    </div>\
  </div>');
  
  function wrapContent() {
    console.debug('init');
    
    $.each(snippets().snippets,function(name,snippet) {
      console.debug(name,snippet);
      snippet.update($('<div data-snippet-name="'+name+'" class="snippet-'+name+'"></div>').append($(snippet.elements())));
    });
  }
    
  function addEditor() {
    
    var snippetName = snippets().names[0];
        
    elements.appendTo('body');
  
    var editor = CodeMirror.fromTextArea($('#code')[0], {
      mode: 'markdown',
      lineNumbers: true,
      matchBrackets: true,
      theme: "default"
    });
  
    var contentDecorator = new ContentDecorator('.snippet-'+snippetName);
  
    contentDecorator.makeDroppable('#gallery img', function(element, positionClass) {
      return $("<img src='" + element.src + "' class='" + positionClass + "' />");
    });
    contentDecorator.addRemoveZone('#gallery');
  
    $.adminDock.title('This is the new title');
    $.adminDock.footer.addButton({ icon: 'picture', showModule: $('#gallery') });
    $.adminDock.footer.addButton({ icon: 'edit', showModule: $('#myContentEditor'), show: function() {
      editor.refresh();
    } });
    $.adminDock.footer.addSelector({
      options: ['main', 'sidebar', 'footer'],
      default: 'sidebar',
      change: function(option) {
        alert("Switching to " + option);
      }
    });
  
    $.adminDock.footer.addButton({ icon: 'upload', text: 'Upload', secondary: true });
    $.adminDock.footer.addButton({ icon: 'undo', text: 'Discard', secondary: true });
    $.adminDock.footer.addButton({ icon: 'save', text: 'Save', secondary: true });
  
    $.adminDock.show('#gallery', false);
  }
  
  $(window).keydown(function(event) {
    if (event.altKey == true && event.keyCode == 27) {

      wrapContent();
      addEditor();
      $.adminDock.toggle();
    }
  });
  
});