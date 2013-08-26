

(function() {
  
  function showFormInPopover(the_form, path) {
    the_form.attr("action",path.replace(/\/(edit|new)$/,''));

    $("#my-pop-over").remove();
    $('.modal').clone().attr("id",'my-pop-over').appendTo("body");
    $("#my-pop-over .modal-body").append(the_form);

    $("#my-pop-over .modal-header h3").text(the_form.find(" > fieldset > legend").text());
    the_form.find(" > fieldset > legend").remove();

    the_form.find(".form-actions").hide();
    the_form.find(".form-actions").find('button, input, a').each(function() {
      var _this = this;
      var new_button = $(this).clone().attr("onclick",'').removeAttr('data-confirm').removeAttr('data-method');
      new_button.appendTo("#my-pop-over .modal-footer");
      new_button.click(function(event) {
        event.preventDefault();
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
  }
  
  window.showFormInPopover = showFormInPopover;
  
}());