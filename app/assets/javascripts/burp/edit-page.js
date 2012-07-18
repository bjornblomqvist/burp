(function() {
  
  $(window.document).on('click','#add-snippet-link',function(event) {
    event.preventDefault();
    
    var snippetName = $('#snippet_name_input').val();
    
    if(snippetName == "") {
      alert("You must enter a snippet name!");
    } else {
      $('<div class="snippet"><label for="page_sidebar">'+snippetName+'</label><a class="remove-snippet-link" href="">Remove snippet</a><textarea id="page_snippet" rows="20" name="page[snippets]['+snippetName+']" cols="40"></textarea></div>').insertBefore("#edit-page-form input[type=\"submit\"]");
    }
    
  })
  
  $(window.document).on('click',".remove-snippet-link",function(event) {
    event.preventDefault();
    $(this).parent().remove();
  });
  
}());