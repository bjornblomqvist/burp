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
    
    var originalValue = $('.snippet-'+snippetName).html();
    $('#code').val(originalValue);
    var lastValue = "";
  
    var editor = CodeMirror.fromTextArea($('#code')[0], {
      mode: 'markdown',
      lineNumbers: true,
      matchBrackets: true,
      theme: "default",
      onUpdate:function() {
        if(editor.getValue() != lastValue) {
          lastValue = editor.getValue();
          contentDecorator.setMarkdown(lastValue);
          // Cleanup
          $('.snippet-'+snippetName).find("p > img").each(function(index,img) {
            if($(img).parent().children().length == 1) {
              $(img).unwrap();
            }
          });
        }
      }
    });
  
    var contentDecorator = new ContentDecorator('.snippet-'+snippetName);
    
    lastValue = editor.getValue();
    contentDecorator.setMarkdown(lastValue);
    // Cleanup
    $('.snippet-'+snippetName).find("p > img").each(function(index,img) {
      if($(img).parent().children().length == 1) {
        $(img).unwrap();
      }
    });
    
    $.getJSON('/burp/files/',function(data) {
      $.each(data.paths,function(index,path) {
        $('#gallery .images').append('<li><img src="'+path+'"></li>');
      });
      
      contentDecorator.makeDroppable('#gallery img', function(element, positionClass) {
        return $("<img src='" + element.src + "' class='" + positionClass + "' />");
      });
    });
  

    contentDecorator.addRemoveZone('#gallery');
  
    $.adminDock.title('This is the new title');
    $.adminDock.footer.addButton({ icon: 'picture', showModule: $('#gallery') });
    $.adminDock.footer.addButton({ icon: 'edit', showModule: $('#myContentEditor'), show: function() {
      editor.refresh();
    } });
    // $.adminDock.footer.addSelector({
    //   options: ['main', 'sidebar', 'footer'],
    //   default: 'sidebar',
    //   change: function(option) {
    //     alert("Switching to " + option);
    //   }
    // });
    
    
    $('<div id="file-uploader" style="overflow: hidden; width: 0px; height: 0px; position: absolute;"></div>').appendTo('body');

    var uploader = new qq.FileUploader({
        element: document.getElementById('file-uploader'),
        action: '/burp/files',
        onComplete: function(id, fileName, responseJSON){
          if(responseJSON.success) {
            $.getJSON('/burp/files/',function(data) {
              
              $('#gallery img').remove();
              
              $.each(data.paths,function(index,path) {
                $('#gallery .images').append('<li><img src="'+path+'"></li>');
              });

              contentDecorator.makeDroppable('#gallery img', function(element, positionClass) {
                return $("<img src='" + element.src + "' class='" + positionClass + "' />");
              });
            });
          } else {
            var errorMessage = "";
            $.each(responseJSON.errors,function(index,error) {
              $.each(error,function(key,value) {
                errorMessage += value;
              });
            });
            alert(errorMessage);
          }
        },
    });
  
    $.adminDock.footer.addButton({ icon: 'upload', text: 'Upload', secondary: true, click:function() {
      $('#file-uploader input').click();
    }});
    $.adminDock.footer.addButton({ icon: 'undo', text: 'Discard', secondary: true, click:function() {
      $('.snippet-'+snippetName).html(originalValue);
      contentDecorator.initImages();
      editor.setValue(lastValue);
    }});
    $.adminDock.footer.addButton({ icon: 'save', text: 'Save', secondary: true, click:function() {
      
      path = window.location.pathname;
      if(path == "/") {
        path = "/$root"
      }
      
      $.ajax("/burp/pages/"+path,{
        cache:false,
        dataType:'json',
        success:function(data) {
          
          data.snippets[snippetName] = contentDecorator.getHtml();
          data.misc = data.misc || {markdown:{}};
          data.misc.markdown[snippetName] = contentDecorator.getMarkdown();

          $.ajax("/burp/pages/"+path+"/update",{
            type:"post",
            data:{page:data},
            dataType:'json',
            success:function() {
              
              originalValue = contentDecorator.getHtml();
              
              alert("The page was saved!")
            }
          });
        }
      });
      
      
    }});
  
    $.adminDock.show('#gallery', false);
    
    path = window.location.pathname;
    if(path == "/") {
      path = "/$root"
    }
    
    $.ajax("/burp/pages/"+path,{
      cache:false,
      dataType:'json',
      success:function(data) {
        var value = "";
        if(data.misc && data.misc.markdown && data.misc.markdown[snippetName]) {
          value = data.misc.markdown[snippetName];
        } else {
          value = data.snippets[snippetName];
        }
        editor.setValue(value);
        
        lastValue = editor.getValue();
        contentDecorator.setMarkdown(lastValue);
        // Cleanup
        $('.snippet-'+snippetName).find("p > img").each(function(index,img) {
          if($(img).parent().children().length == 1) {
            $(img).unwrap();
          }
        });
      }
    });
  }
  
  var initDone = false;
  
  function init() {
    if(!initDone) {
      wrapContent();
      addEditor();
      initDone = true;
    }
  }
  
  $(window).keydown(function(event) {
    if (event.altKey == true && event.keyCode == 27) {

      init();
      
      $.adminDock.toggle();
    }
  });
  
});