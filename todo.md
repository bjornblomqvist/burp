- Setup a demo page
- Setup website, burp.com with this image as mascot http://venkman-project.deviantart.com/art/Bubble-Burp-109862317
- Fix so that it is easy to get started
- The usage insturtions must actualy work
- Setup travis-ci
- Add persona based login solution with basic roles (Admin, user).
  User can do the usual things. Admin can add users and other admins. Admin can not remove him/her self.
    https://developer.mozilla.org/en-US/Persona
- Change so that Menus are just groups and links. 
- Have the url part of links do Typeahead. See (http://getbootstrap.com/2.3.2/javascript.html#typeahead) and http://twitter.github.io/typeahead.js
  The hope is to teach the users that its a tree of links
- Add option to edit the raw link
- Make html output a bit nicer with https://github.com/threedaymonk/htmlbeautifier
- Change so that we serve uploaded files via /public. We do this by adding a symlink   
- Add globals, they are always available.
- Add string snippets to a page. This could be title,meta-description,keywords
- Add support for multiple layouts
- Only layouts listed in the config are available. (burp.layouts = ["application", "app2", "something else"])
- Have the layouts be shown in a dropdown list when editing the a page

- Add new API
```
Burp.pages[request].exists?
Burp.pages[request].save
Burp.pages[request].save!
Burp.pages[request].reload
Burp.pages[request].reload!
Burp.pages[request].layout
Burp.pages[request].group
Burp.pages[request].title
Burp.pages[request].menus[:main]
Burp.pages[request].menus[:sub_menu]
Burp.pages[request].menus[:main].save
Burp.pages[request].menus[:main].save!
Burp.pages[request].menus[:main].reload
Burp.pages[request].menus[:main].reload!
Burp.pages[request].strings[:title]
Burp.pages[@burp_page_path].strings[:title]
Burp.pages[@burp_page_path].snippets[:body]

Burp.global.title
Burp.global.layout
Burp.global.save
Burp.global.save!
Burp.global.reload
Burp.global.reload!
Burp.global.menus[:main]
Burp.global.menus[:sub_menu]
Burp.global.strings[:meta_description]
Burp.global.snippets[:footer]

Burp.groups["extra-info"].menus[:main]
Burp.groups["extra-info"].menus[:sub_menu]
Burp.groups["extra-info"].group.strings[:meta_description]
Burp.groups["extra-info"].group.snippets[:meta_description]

Burp.pages[request].group.strings[:meta_description]
Burp.pages[request].group.snippets[:footer]

page.title || page.group.title || Burp.global.title

page.snippet(:sidebar, :with_fallback) || page.group[:sidebar] || Burp.global[:sidebar]

```
- Have most stuff be editable in the editor. Only show what the layout have just tried to render
- Add new config
```
Rails.application.config.burp do 
    layouts = ["application", "firstpage"]
    username = "..."
    password = "..."
    use_persona = true
end
```
- Add option of adding a page to a group. Some kind of dropdown with the option of adding a new group
- Add strings editing to the editor, have multiline strings be shown as textareas
- Write API Documentation    
- Add progress bar for file uploads in edit mode
- Add handeling of all form errors    
- Make a API for the editor to use communicating with the server and when updating the page. 
  
  
   
  
  
  
  
  
  
  
  
  
  
  
  


- Fix so that style elment content dont get escaped by the markdown parser
- Write menu edit drag and drop tests
- Write image drag and drop tests
- Write a test for the pages not in menu feature
