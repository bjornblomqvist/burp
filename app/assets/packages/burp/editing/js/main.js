/*global
    snippets CodeMirror ContentDecorator qq
*/

$(function() {
  
  var elements = $('<div style="display: none;"><div id="gallery" style="display: none;"><ul class="images"></ul><i class="prev icon-large enabled icon-caret-left"></i><i class="next icon-large enabled icon-caret-right"></i></div><div id="myContentEditor" style="display: none;"><textarea id="code" style="width: 100%; height: 300px;"></textarea></div></div>');
  var lastValue;
  var snippetName;
  
  function wrapContent() {
    $.each(snippets().snippets,function(name,snippet) {
      console.debug(name,snippet);
      snippet.update($('<div data-snippet-name="'+name+'" class="snippet-'+name+'"></div>').append($(snippet.elements())));
    });
  }
  
  function cleanup(container) {
    container.find("p > img").each(function(index,img) {
      if($(img).parent().children().length === 1) {
        $(img).unwrap();
      }
    });
  }
  
  function update(value,contentDecorator) {
    if(value !== lastValue) {
      lastValue = value;
      contentDecorator.setMarkdown(value);
      cleanup($('.snippet-'+snippetName));
    }
  }
  
  function loadFiles(contentDecorator) {
    
    $.getJSON('/burp/files/',function(data) {
      
      $('#gallery img').remove();
      
      $.each(data.paths,function(index,path) {
        $('#gallery .images').append('<li><img src="'+path+'"></li>');
      });

      contentDecorator.makeDroppable('#gallery img', function(element, positionClass) {
        return $("<img src='" + element.src + "' class='" + positionClass + "' />");
      });
      
      $('#gallery').trigger('reset');
    });
  }
  
  function showJSONErrors(responseJSON) {
    var errorMessage = "";
    $.each(responseJSON.errors,function(index,error) {
      $.each(error,function(key,value) {
        errorMessage += value;
      });
    });
    alert(errorMessage);
  }
    
  function addEditor() {
    
    snippetName = snippets().names[0];
        
    elements.appendTo('body');
    
    var originalValue = $('.snippet-'+snippetName).html();
    $('#code').val(originalValue);
  
    var contentDecorator = new ContentDecorator('.snippet-'+snippetName);
    window.contentDecorator = contentDecorator;
  
    var editor = CodeMirror.fromTextArea($('#code')[0], {
      mode: 'markdown',
      lineNumbers: true,
      matchBrackets: true,
      theme: "default",
      onChange:function(editor,changes) {
        update(editor.getValue(),contentDecorator);
      }
    });
    
    $(document).on('dblclick','#gallery li img',function() {
      var url = $(this).attr('src');
      $('.admin-dock .icon-edit').click();
      editor.focus();
      editor.replaceRange('<img src="'+url+'">',editor.getCursor(true),editor.getCursor(false));
    });
    
    update(editor.getValue(),contentDecorator);
    loadFiles(contentDecorator);

    contentDecorator.addRemoveZone('#gallery');
  
    $.adminDock.title('');
    $.adminDock.footer.addButton({ icon: 'picture', showModule: $('#gallery') });
    $.adminDock.footer.addButton({ icon: 'edit', showModule: $('#myContentEditor'), show: function() {
      editor.refresh();
    } });

    var snippet_names = [];
    $.each(snippets().snippets,function(name,snippet) {
      snippet_names.push(name);
    });
    
    $.adminDock.footer.addSelector({
      options: snippet_names,
      default: snippet_names[0],
      change: function(option) {
        
        alert("Switching to " + option);
      }
    });
    

    $('<div id="file-uploader" style="overflow: hidden; width: 0px; height: 0px; position: absolute;"></div>').appendTo('body');

    var uploader = new qq.FileUploader({
        element: document.getElementById('file-uploader'),
        action: '/burp/files',
        onComplete: function(id, fileName, responseJSON){
          if(responseJSON.success) {
            loadFiles(contentDecorator);
          } else {
            showJSONErrors(responseJSON);
          }
        }
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
      
      var path = window.location.pathname;
      if(path === "/") {
        path = "/$root";
      }
      
      $.ajax("/burp/pages/"+path,{
        cache:false,
        dataType:'json',
        success:function(data) {
          
          data = data || {snippets:{}};
          
          data.snippets[snippetName] = contentDecorator.getHtml();
          data.misc = data.misc || {markdown:{}};
          data.misc.markdown[snippetName] = contentDecorator.getMarkdown();

          $.ajax("/burp/pages/"+path+"/update",{
            type:"post",
            data:{page:data},
            dataType:'json',
            success:function() {
              
              originalValue = contentDecorator.getHtml();
              
              alert("The page was saved!");
            }
          });
        }
      });
      
      
    }});
  
    $.adminDock.show('#gallery', false);
    
    var path = window.location.pathname;
    if(path === "/") {
      path = "/$root";
    }
    
    $.ajax("/burp/pages/"+path,{
      cache:false,
      dataType:'json',
      success:function(data) {
        if(data == null) {
          return; // There is no page yet
        }
        
        var value = "";
        if(data.misc && data.misc.markdown && data.misc.markdown[snippetName]) {
          value = data.misc.markdown[snippetName];
        } else {
          value = data.snippets[snippetName];
        }
        
        editor.setValue(value);
        editor.clearHistory();
        
        update(editor.getValue(),contentDecorator);
      }
    });
  }
  
  var initDone = false;
  
  function init() {
    if(!initDone) {
      initDone = true;
      
      wrapContent();
      addEditor();
      
      $('#gallery').trigger('refresh');
      setTimeout(function() { $('#gallery').trigger('refresh'); },300);
      setTimeout(function() { $('#gallery').trigger('refresh'); },600);
      setTimeout(function() { $('#gallery').trigger('refresh'); },1200);
      setTimeout(function() { $('#gallery').trigger('refresh'); },5000);
    }
  }
  
  $(window).keydown(function(event) {
    if (event.altKey === true && event.keyCode === 27) {

      init();
      
      $.adminDock.toggle();
    }
  });
  
  $(window).resize(function() {
    $('#gallery').trigger('refresh');
  });
  
});