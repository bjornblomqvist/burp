/*global
  burp
*/

(function() {
  
  burp.saveMenu = function saveMenu(menu) {
    $.put("./",{menu:JSON.stringify(menu)},function() {
      $.debug("Menu changes saved!");
    });
  };
  
  $.fn.serializeGroup = function() {
    if($(this).is("section.group")) {
      // Link clanup
      $(this).find('a').each(function() {
        if($(this).attr('orginial-url')) {
          $(this).attr('href',$(this).attr('orginial-url'));
          $(this).removeAttr('orginial-url');
        }
      });
      
      return {
        name:($(this).find("> .group-name").text()),
        children:$(this).find("> ul.children > li").map(function() {
          if($(this).is(".link")) {
            var a = $(this).find('a');
            return {name:a.text(), url:a.attr("href")};
          } else if($(this).is(".group")) {
            return $(this).find('> section.group').serializeGroup();
          }
        }).toArray()
      };
    }
  };
}());
