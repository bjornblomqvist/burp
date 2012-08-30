/*global
    snippets CodeMirror ContentDecorator qq
*/

$(function() {
  
  var elements = $('<div style="display: none;"><div id="gallery" style="display: none;"><ul class="images"></ul><i class="prev icon-large enabled icon-caret-left"></i><i class="next icon-large enabled icon-caret-right"></i></div><div id="myContentEditor" style="display: none;"><textarea id="code" style="width: 100%; height: 300px;"></textarea></div></div>');
  var lastValue;
  var snippetName;
  var originalHtml;
  var originalValue;
  var contentDecorator;
  var editor;
  
  function wrapContent() {
    $.each(snippets().snippets,function(name,snippet) {
      console.debug(name,snippet);
      snippet.update($('<div data-snippet-name="'+name+'" class="snippet-wrapper snippet-'+name+'"></div>').append($(snippet.elements())));
    });
  }
  
  function cleanup(container) {
    container.find("p > img").each(function(index,img) {
      if($(img).parent().children().length === 1) {
        $(img).unwrap();
      }
    });
  }
  
  function update(value) {
    if(value !== lastValue) {
      lastValue = value;
      contentDecorator.setMarkdown(value);
      cleanup($('.snippet-'+snippetName));
    }
  }
  
  function loadFiles() {
    
    $.getJSON('/burp/files/',function(data) {
      
      $('#gallery img').remove();
      
      $.each(data.paths,function(index,path) {
        $('#gallery .images').append('<li><img src="'+path+'"></li>');
      });

      contentDecorator.makeDroppable('#gallery img', function(element, positionClass) {
        return $("<img src='" + $(element).attr('src') + "' class='" + positionClass + "' />");
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
  
  function selectSnippet(_snippetName) {
    
    if(contentDecorator) {
      contentDecorator.cleanup();
      contentDecorator.removeDroppable($('#gallery img'));
    }
    
    snippetName = _snippetName;
    originalHtml = $('.snippet-'+snippetName).html();
    contentDecorator = new ContentDecorator('.snippet-'+snippetName);
    contentDecorator.addRemoveZone('#gallery');
    $('#code').val(originalHtml);
    
  }
    
  function addEditor() {
    
    elements.appendTo('body');
    $('#code').val(originalHtml);
  
    editor = CodeMirror.fromTextArea($('#code')[0], {
      mode: 'markdown',
      lineNumbers: true,
      matchBrackets: true,
      theme: "default",
      onChange:function(editor,changes) {
        update(editor.getValue());
      }
    });
    
    $(document).on('dblclick.burp','#gallery li img',function() {
      var url = $(this).attr('src');
      $('.admin-dock .icon-edit').click();
      editor.focus();
      editor.replaceRange('<img src="'+url+'">',editor.getCursor(true),editor.getCursor(false));
    });

    contentDecorator.addRemoveZone('#gallery');
    
    update(editor.getValue());
    loadFiles();
  
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
        
        
        selectSnippet(option);
        loadSnippet();
        
        $('#gallery img').removeClass('movable');
        contentDecorator.makeDroppable('#gallery img', function(element, positionClass) {
          return $("<img src='" + $(element).attr('src') + "' class='" + positionClass + "' />");
        });
        
        console.debug("Switching to " + option);
      }
    });
    

    $('<div id="file-uploader" style="overflow: hidden; width: 0px; height: 0px; position: absolute;"></div>').appendTo('body');

    var upload_data = {};
    upload_data[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content');

    var uploader = new qq.FileUploader({
        element: document.getElementById('file-uploader'),
        params: upload_data,
        action: '/burp/files',
        onComplete: function(id, fileName, responseJSON){
          if(responseJSON.success) {
            loadFiles();
          } else {
            showJSONErrors(responseJSON);
          }
        }
    });
  
    $.adminDock.footer.addButton({ icon: 'upload', text: 'Upload', secondary: true, click:function() {
      $('#file-uploader input').click();
    }});
    
    $.adminDock.footer.addButton({ icon: 'undo', text: 'Discard', secondary: true, click:function() {
      // We set this as it holds all the images as when we started
      $('.snippet-'+snippetName).html(originalHtml);
      contentDecorator.init();
      editor.setValue(originalValue);
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
              
              originalValue = contentDecorator.getMarkdown();
              originalHtml = contentDecorator.getHtml();
              
              alert("The page was saved!");
            }
          });
        }
      });
      
      
    }});
  
    $.adminDock.show('#gallery', false);
  }
  
  function loadSnippet() {
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
        
        // We default to the html
        var value = originalHtml;
        if(data.misc && data.misc.markdown && data.misc.markdown[snippetName]) {
          value = data.misc.markdown[snippetName];
        } else if(data.snippets[snippetName]) {
          value = data.snippets[snippetName];
        }
        
        originalValue = value;
        editor.setValue(value);
        editor.clearHistory();
        
        update(editor.getValue());
      }
    });
  }
  
  var initDone = false;
  
  function init() {
    if(!initDone) {
      initDone = true;
      
      wrapContent();
      selectSnippet(snippets().names[0]);
      addEditor();
      loadSnippet();
      
      $('#gallery').trigger('refresh');
      setTimeout(function() { $('#gallery').trigger('refresh'); },300);
      setTimeout(function() { $('#gallery').trigger('refresh'); },600);
      setTimeout(function() { $('#gallery').trigger('refresh'); },1200);
      setTimeout(function() { $('#gallery').trigger('refresh'); },5000);
    }
  }
  
  $(window).keyup(function(event) {
    if ((event.altKey === true || event.ctrlKey === true ) && event.keyCode === 27) {

      init();
      
      $.adminDock.toggle();
    }
  });
  
  $(window).resize(function() {
    $('#gallery').trigger('refresh');
  });
  
});