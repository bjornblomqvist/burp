/*global
  
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
        
        var the_form = $(data).find("form");
        the_form.attr("action",path);

        $("#my-pop-over").remove();
        $('.modal').clone().attr("id",'my-pop-over').appendTo("body");
        $("#my-pop-over .modal-body").append(the_form);
        
        $("#my-pop-over .modal-header h3").text(the_form.find(" > fieldset > legend").text());
        the_form.find(" > fieldset > legend").remove();
        
        the_form.find(".form-actions").hide();
        the_form.find(".form-actions button").each(function() {
          var _this = this;
          var new_button = $(this).clone().attr("onclick",'');
          new_button.appendTo("#my-pop-over .modal-footer");
          new_button.click(function() {
            if($(this).text() === "Cancel") {
              $("#my-pop-over").modal("hide");
            } else {
              $(_this).click();
            }
          });
        });
        
        $("#my-pop-over").modal('show').one('shown',function() {
          $(this).find('input').not("input[type=button],input[type=hidden],input[type=submit]").first().focus();
        });
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
        
        var the_form = $(data).find("form");
        the_form.attr("action",path.replace(/\/(edit|new)$/,''));

        $("#my-pop-over").remove();
        $('.modal').clone().attr("id",'my-pop-over').appendTo("body");
        $("#my-pop-over .modal-body").append(the_form);
        
        $("#my-pop-over .modal-header h3").text(the_form.find(" > fieldset > legend").text());
        the_form.find(" > fieldset > legend").remove();
        
        the_form.find(".form-actions").hide();
        the_form.find(".form-actions button").each(function() {
          var _this = this;
          var new_button = $(this).clone().attr("onclick",'');
          new_button.appendTo("#my-pop-over .modal-footer");
          new_button.click(function() {
            if($(this).text() === "Cancel") {
              $("#my-pop-over").modal("hide");
            } else {
              $(_this).click();
            }
          });
        });
        
        $("#my-pop-over").modal('show').one('shown',function() {
          $(this).find('input').not("input[type=button],input[type=hidden],input[type=submit]").first().focus();
        });
      });
    });
  });
  
  
});