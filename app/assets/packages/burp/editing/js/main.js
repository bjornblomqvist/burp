/*global
    snippets CodeMirror ContentDecorator qq Html2Markdown
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
      
      // Fix so that we dont run javascript again
      $(snippet.elements()).each(function() {
        if($(this).is("script")) {
          $(this).attr("type",'text/dont-run-javascript');
        } else {
          $(this).find("script").each(function() {
            $(this).attr("type",'text/dont-run-javascript');
          });
        }
      });
      
      snippet.update($('<div data-snippet-name="'+name+'" class="snippet-wrapper snippet-'+name+'"></div>').append($(snippet.elements())));
    });
    
    // Remove unwanted stuff
    $('.burp-remove, .remove-on-save').remove();
    $('.burp-unwrap').each(function() {$(this).replaceWith(this.children);});
  }
  
  function cleanup(container) {
    container.find("p").each(function() {
      if($(this).children().length === $(this).find('img').length) {
        $(this).children().unwrap();
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
  
  function loadHTML() {
     
     var element = snippets().snippets[snippetName].elements().clone();
     element.find('.markdown').each(function() {
       $(this).removeClass('markdown');
       if($(this).attr('class') === "") {
         $(this).removeAttr('class');
       }
     });
     
     element.find('script[type="text/dont-run-javascript"]').each(function() {
       $(this).attr("type",'text/javascript');
     });
     
     element.find('img.movable').each(function() {
       $(this).removeClass('movable ui-draggable ui-droppable');
     });
     
     editor.setValue(Html2Markdown(element.children()));
  }
  
  function loadSnippet() {
     var path = window.burp_path || window.location.pathname;
     if(path === "/") {
       path = "/$root";
     }
     
     loadHTML();
     editor.clearHistory();
     update(editor.getValue());
     originalValue = editor.getValue();
   }
  
  function loadFiles() {
    
    $.getJSON('/burp/files/',function(data) {
      
      $('#gallery .images li').remove();
      
      $.each(data.paths,function(index,path) {
        var pathParts = path.split("/");
        var fileName = pathParts[pathParts.length-1];
        if(fileName.match(/\.(png|jpeg|jpg|gif)$/i)) {
          $('#gallery .images').append('<li title="'+fileName+'"><img src="'+path.replace(/(\/files\/)/,'/files/small/')+'"><span  class="position-helper"><label>'+fileName+'</label><span></li>');
        } else {
          $('#gallery .images').append('<li title="'+fileName+'"><span path="'+path+'" class="click-area">Double click to add file</span><span class="position-helper"><label>'+fileName+'</label><span></li>');
        }
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
      lineWrapping: true,
      theme: "default",
      onChange:function(editor,changes) {
        update(editor.getValue());
      }
    });
    
    $(document).on('dblclick.burp','#gallery li img, #gallery li .click-area',function(event) {
      event.preventDefault();
      
      var url = $(this).attr('src') || $(this).attr('path');
      $('.admin-dock .icon-edit').click();
      editor.focus();
      var textToLink = editor.getRange(editor.getCursor(true),editor.getCursor(false));
      if(textToLink === "") {
        textToLink = url;
      }
      
      // Use link to large image
      if(url.match(/(png|jpeg|gif|jpg)/i)) {
        url = url.replace(/\/files\/small\//,'/files/large/');
      }
      
      var content = url.match(/\.(png|jpeg|jpg|gif)$/i) ? '<img src="'+url+'">' : '<a href="'+url+'">'+textToLink+'</a>';
      editor.replaceRange(content,editor.getCursor(true),editor.getCursor(false));
    });

    contentDecorator.addRemoveZone('#gallery');
    
    // update(editor.getValue());
    loadFiles();
  
    $.adminDock.title('');
    $.adminDock.footer.addButton({ icon: 'picture', text: "Pictures", showModule: $('#gallery') });
    $.adminDock.footer.addButton({ icon: 'edit', text: "Edit text", showModule: $('#myContentEditor'), show: function() {
      loadHTML();
      editor.refresh();
    } });
    
    
    $(document).on('image-drop-done.burp', function() {
      loadHTML();
      editor.refresh();
    });

    var snippet_names = [];
    $.each(snippets().snippets,function(name,snippet) {
      snippet_names.push(name);
    });
    
    snippet_names.sort(function(a, b) { return a.toLowerCase() > b.toLowerCase(); });
    
    
    // Why show snippet selection when there is only one
    if(snippet_names.length > 1) {
      $.adminDock.footer.addSelector({
        options: snippet_names,
        'default': snippet_names[0],
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
    }
    

    $('<div id="file-uploader" style="overflow: hidden; width: 0px; height: 0px; position: absolute;"></div>').appendTo('body');


    var uploader = new qq.FileUploader({
        element: document.getElementById('file-uploader'),
        params: {authenticity_token : $('meta[name=csrf-token]').attr('content')},
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
    
    $.adminDock.footer.addButton({ icon: 'signin', text: 'Go to Burp', click:function() {
      window.location = "/burp/pages/";
    }});
    
    $.adminDock.footer.addButton({ icon: 'undo', text: 'Discard', secondary: true, click:function() {
      // We set this as it holds all the images as when we started
      $('.snippet-'+snippetName).html(originalHtml);
      contentDecorator.init();
      editor.setValue(originalValue);
    }});
    
    $.adminDock.footer.addButton({ icon: 'save', text: 'Save', secondary: true, click:function() {
      
      var path = window.burp_path || snippets().snippets[snippetName].pageId || window.location.pathname;
      if(path === "/") {
        path = "/$root";
      }
      
      $.ajax("/burp/pages/"+path,{
        cache:false,
        dataType:'json',
        success:function(data) {
          
          data = data || {snippets:{}};
          
          data.snippets[snippetName] = contentDecorator.getHtml();

          $.ajax("/burp/pages/"+path,{
            type:"post",
            data:{page:data,'_method':"put"},
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
  
  var initDone = false;
  
  function init() {
    if(!initDone) {
      initDone = true;
      
      wrapContent();
      selectSnippet(snippets().names.sort(function(a, b) { return a.toLowerCase() > b.toLowerCase(); })[0]);
      addEditor();
      
      loadSnippet();
      
      $('#gallery').trigger('refresh');
      setTimeout(function() { $('#gallery').trigger('refresh'); },300);
      setTimeout(function() { $('#gallery').trigger('refresh'); },600);
      setTimeout(function() { $('#gallery').trigger('refresh'); },1200);
      setTimeout(function() { $('#gallery').trigger('refresh'); },5000);
    }
  }
  
  function trigger_http_basic_auth(callback) {
    if(initDone) {
      callback();
    } else {
      $.get("/burp/",callback);
    }
  }
  
  var start_time;
  
  $(window).keydown(function(event) {
    if (
      ((event.altKey === true || event.ctrlKey === true ) && event.keyCode === 27) ||
      (event.altKey === true && event.ctrlKey === true && event.keyCode === 32)
      ) {
        
      if(!start_time || start_time.getTime() + 1000 < new Date().getTime()) {
        trigger_http_basic_auth(function() {
          init();
          $.adminDock.toggle();
          start_time = null;
        });
      }
    }
  });
  
  $(window).resize(function() {
    $('#gallery').trigger('refresh');
  });
  
});