/*global
    snippets CodeMirror ContentDecorator qq Html2Markdown markdown2Html burp
*/

$(function() {
  
  var elements = $('<div style="display: none;"><div id="gallery" style="display: none;"><ul class="images"></ul><i class="prev icon-large enabled icon-caret-left"></i><i class="next icon-large enabled icon-caret-right"></i></div><div id="myContentEditor" style="display: none;"><textarea id="code" style="width: 100%; height: 300px;"></textarea></div></div>');
  var lastValue;
  var snippetName;
  var originalHtml;
  var originalValue;
  var contentDecorator;
  var editor;
  
  function getPathFor(snippetName) {
    var path = window.burp_path || snippets().snippets[snippetName].pageId || window.location.pathname;
    if(path === "/") {
      path = "/$root";
    }
    
    return path;
  }
  
  var snippetCache = {};
  
  function getHTMLForSnippet(_snippetName, callback) {
    var path = getPathFor(snippetName);
    
    var cacheKey = path + _snippetName;
    if(snippetCache[cacheKey]) {
      setTimeout(function() {
        callback(snippetCache[cacheKey]);
      }, 0);
    } else {    
      $.ajax("/burp/pages/"+path,{
         cache:false,
         dataType:'json',
         success:function(data) {
           data = data || {snippets:{}};
           snippetCache[cacheKey] = data.snippets[snippetName];
           callback(snippetCache[cacheKey]);
         }
       });
    }
  }
  
  var snippetEditorState = {};
  
  function loadSnippet(snippetName, callback) {
     var path = getPathFor(snippetName);
     
     if(typeof(callback) === "undefined") {
       callback = function() {};
     }
     
     if(snippetEditorState[snippetName]) {
        callback(snippetEditorState[snippetName]);
     } else {
       getHTMLForSnippet(snippetName, function(html) {

          var element = $("<div>" + html + "</div>");

          element.find('script[type="text/dont-run-javascript"]').each(function() {
           $(this).attr("type",'text/javascript');
          });

          element.find('img.movable').each(function() {
           $(this).removeClass('movable ui-draggable ui-droppable');
          });

          snippetEditorState[snippetName] = Html2Markdown(element.children());
          callback(snippetEditorState[snippetName]);
       });
     }
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

    snippetName = _snippetName;
    loadSnippet(snippetName, function(snippet) {
      editor.setValue(snippet);
      editor.refresh();
    });
    
    contentDecorator.setSnippetName(snippetName);
  }
  
  function removeIDs(elements) {
    
    $(elements).each(function() {
      $(this).removeAttr("eid");
    });
    
    $(elements).find('*').each(function() {
      $(this).removeAttr("eid");
    });
    
    return elements;
  }
  
  function addIDs(snippetName, elements) {
    
    var count = 0;
    
    $(elements).each(function() {
      $(this).attr("eid", snippetName + "-" + String(count++));
    });
    
    $(elements).find('*').each(function() {
      $(this).attr("eid", snippetName + "-" +String(count++));
    });
    
    return elements;
  }
  
  var domSnippetState = {};
  
  function updateSnippetWithMarkdown(snippetName, markdown) {
    var html = markdown2Html(markdown);
    var elements = burp.disableScriptElements($(html));
    elements = addIDs(snippetName, elements);
    domSnippetState[snippetName] = elements.clone();
    snippets().snippets[snippetName].update(elements);
    
    contentDecorator.makeDroppable(elements, function(element, positionClass) {
      return $("<img src='" + $(element).attr('src') + "' class='" + positionClass + "' />");
    });
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
      onChange:function(editor, changes) {
        snippetEditorState[snippetName] = editor.getValue();
        updateSnippetWithMarkdown(snippetName, snippetEditorState[snippetName]);
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

    loadFiles();
  
    $.adminDock.title('');
    $.adminDock.footer.addButton({ icon: 'picture', text: "Pictures", showModule: $('#gallery') });
    $.adminDock.footer.addButton({ icon: 'edit', text: "Edit text", showModule: $('#myContentEditor'), show: function() {
      editor.refresh();
    } });
    
    
    $(document).on('image-drop-done.burp', function() {
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
          loadSnippet(snippetName, function(snippet) {
            editor.setValue(snippet);
            editor.refresh();
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
      
      var oldSnippetEditorState = snippetEditorState;
      snippetEditorState = {};
      
      $.each(oldSnippetEditorState, function(snippetName, editorState) {
        loadSnippet(snippetName, function(snippet) {
          updateSnippetWithMarkdown(snippetName, snippet);
        });
      });
      
      loadSnippet(snippetName, function(snippet) {
        editor.setValue(snippet);
        editor.refresh();
      });
    }});
    
    $.adminDock.footer.addButton({ icon: 'save', text: 'Save', secondary: true, click:function() {
      
      var path = getPathFor(snippetName);
      snippetCache = {};
      
      $.ajax("/burp/pages/"+path,{
        cache: false,
        dataType: 'json',
        success: function(data) {
          
          data = data || {snippets:{}};
          
          $.each(snippetEditorState, function(snippetName, snippetState) {
            data.snippets[snippetName] = markdown2Html(snippetEditorState[snippetName]);
          });
          
          $.ajax("/burp/pages/"+path,{
            type:"post",
            data:{page:data,'_method':"put"},
            dataType:'json',
            success:function() {
              alert("The page has been saved!");
            }
          });
        }
      });
      
      
    }});
  
    $.adminDock.show('#gallery', false);
  }
  
  var initDone = false;
  
  function trigger_http_basic_auth(callback) {
    if(initDone) {
      callback();
    } else {
      $.get("/burp/",callback);
    }
  }
  
  function init(callback) {
    trigger_http_basic_auth(function() {
      if(!initDone) {
        initDone = true;
      
        contentDecorator = new ContentDecorator("");
        contentDecorator.setCallbacks({
          remove: function(element) {
            var eid = element.attr('eid');
            var snippetName = eid.split(/-/)[0];
            
            var cssSelector = '[eid="'+ eid +'"]';
            
            var root = $('<div></div>');
            root.append(domSnippetState[snippetName]);
            root.find(cssSelector).remove();
            domSnippetState[snippetName] = root.children();
            
            snippetEditorState[snippetName] = Html2Markdown(removeIDs(domSnippetState[snippetName]));
            loadSnippet(snippetName, function(snippet) {
              editor.setValue(snippet);
              editor.refresh();
            });
          },
          insertBefore: function(beforeElement, element) {
            $(element).removeClass('ui-droppable movable ui-draggable');
            
            var eid = beforeElement.attr('eid');
            var snippetName = eid.split(/-/)[0];
            
            var cssSelector = '[eid="'+ eid +'"]';
            
            var root = $('<div></div>');
            root.append(domSnippetState[snippetName]);
            element.insertBefore(root.find(cssSelector));
            domSnippetState[snippetName] = root.children();
            
            snippetEditorState[snippetName] = Html2Markdown(removeIDs(domSnippetState[snippetName]));
            loadSnippet(snippetName, function(snippet) {
              editor.setValue(snippet);
              editor.refresh();
            });
          },
          append: function(snippetName, element) {
            $(element).removeClass('ui-droppable movable ui-draggable');
            
            domSnippetState[snippetName] = $('<div></div>').append(domSnippetState[snippetName]).append(element).children();
            
            snippetEditorState[snippetName] = Html2Markdown(removeIDs(domSnippetState[snippetName]));
            loadSnippet(snippetName, function(snippet) {
              editor.setValue(snippet);
              editor.refresh();
            });
          }
        });
      
        selectSnippet(snippets().names.sort(function(a, b) { return a.toLowerCase() > b.toLowerCase(); })[0]);
        addEditor();
        
        contentDecorator.addRemoveZone('#gallery');
      
        loadSnippet(snippetName, function(snippet) {
          editor.setValue(snippet);
          editor.refresh();
        });
      
        $('#gallery').trigger('refresh');
        setTimeout(function() { $('#gallery').trigger('refresh'); },300);
        setTimeout(function() { $('#gallery').trigger('refresh'); },600);
        setTimeout(function() { $('#gallery').trigger('refresh'); },1200);
        setTimeout(function() { $('#gallery').trigger('refresh'); },5000);
      }
    
      callback();
    });
  }
  
  function isCtrlOrAltEscape(event) {
    return (event.altKey === true || event.ctrlKey === true ) && event.keyCode === 27;
  }
  
  function isCtrlAltSpace(event) {
    return event.altKey === true && event.ctrlKey === true && event.keyCode === 32;
  }
  
  $(window).keydown(function(event) {
    if (isCtrlOrAltEscape(event) || isCtrlAltSpace(event)) {        
      init(function() {
        $.adminDock.toggle();
      });
    }
  });
  
  $(window).resize(function() {
    $('#gallery').trigger('refresh');
  });
  
});