(function() {
  
  $(window.document).on('click','#add-snippet-link',function(event) {
    event.preventDefault();
    
    var snippetName = $('#snippet_name_input').val();
    
    if(snippetName == "") {
      alert("You must enter a snippet name!");
    } else {
      $('<div class="control-group"><label for="page_snippet" class="control-label">'+snippetName+'</label><div class="controls"><span class="input"><textarea rows="20" name="page[snippets]['+snippetName+']" id="page_snippet" cols="40"></textarea><span class="help-block"><a href="" class="remove-snippet-link">Remove snippet</a></span></span></div></div>').insertAfter("#snippet-set > legend");
      $('#snippet_name_input').val("");
    }
    
  })
  
  $(window.document).on('click',".remove-snippet-link",function(event) {
    event.preventDefault();
    $(this).closest(".control-group").remove();
  });
  
}());