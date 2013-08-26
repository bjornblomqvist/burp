/*global
  showFormInPopover
*/


$(function() {
  
  $(function() {
    
    $(document).on('click',".dnd-editable-menu.not-editable a",function(event) {
      event.preventDefault();
    });
    
    $(document).on('click',".dnd-editable-menu.editable a, .dnd-editable-menu.editable .group-name",function(event) {
      event.preventDefault();
      
      var target = $(event.target);
      
      if(target.is(".group-name")) {
        target = target.closest("section.group");
      }
      
      // We dont do editing of links in the "Pages not in the above menu"
      if($(target).closest('section[id]').length === 0) {
        return;
      }
      
      var id = $(target).attr('id');
      
      var path = $(target).is("a") ? "./links/"+id : "./groups/"+id;
      
      $.get(path+"/edit",function(data) {
        showFormInPopover($(data).find("form"), path);
      });
    });
  });
  
  
  $(function() {
    
    // Popup for edit and new page
    $(document).on('click',"a.new-link-link, a.new-group-link",function(event) {
      event.preventDefault();
      
      var target = $(event.target);
      
      var path = target.attr('href');
      
      $.get(path,function(data) {
        showFormInPopover($(data).find("form"), path);
      });
    });
  });
  
  
});