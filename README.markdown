# Burp

_The Big Universal Rubik's cube Processor_

Until we figure out how solve a Rubiks cube your welcome to use Burp as a CMS.

### Why Burp?

We think most CMS are some where between bad and awful!

So we created a new one in hope that we and others would like it. We have 3 guiding goals that help us stay away from bad and awful.

- Don't hinder the developer.
- Don't try to solve everything.
- Don't be ugly.

## Screenshots

**In the admin**
![The admin](https://raw.github.com/bjornblomqvist/burp/master/app/assets/images/burp/change-page-title-1.png)

**Adding an image**
![Adding an image](https://raw.github.com/bjornblomqvist/burp/master/app/assets/images/burp/remove-image-5.jpg)

**Editing text**
![Text editing](https://raw.github.com/bjornblomqvist/burp/master/app/assets/images/burp/change-the-text-2.png)

## Installation

Add the gem to your Gemfile
```ruby
gem 'burp_cms'
```
    
Install the gem and init burp.
```bash
bundle install
rake burp:init
```

You can find the admin on /burp/ and the default admin password in ./config/initializers/burp_access.rb.

## CMS Page's

There is a controller called CatchAll in the Rails engine that catches all requests not cought by any other rules. When a request has a path that
matches one of the CMS pages then that CMS page is loaded and shown.

### Snippets

An example for a sidebar snippet.
```erb
<%= @cms_page[:sidebar] %>
```

#### Snippets on other pages

To use snippets on pages not cought by the CatchAllController. The or part is to stop errors do to nil. 
```ruby
before_filter :load_cms_page
def load_cms_page
  @cms_page = Burp.find_page(request.path) || Burp::Page.new(:id => request.path)
end
```

## Title
```erb
<title><%= @cms_page.title %></title>
```
    
## Meta description
```erb
<meta name="description" content="<%= @cms_page.meta_description %>" >
```

## Menu

### Render the menu
```erb
<%= @menu.to_html(request) %>
```
    
Or do it manualy
```erb
<nav>
  <ul>
    <% @menu.children.select{|child| child.is_a?(Burp::Link) }.each do |child| %>
    <li class="<%= child.css_class %> <%= child.current?(request) ? "active" : "" %>"><%= child.to_html %></li>
    <% end %>
  </ul>
</nav>
```

### Use menu on none CMS pages.  

The @menu variable is only available for pages served with the catch_all controller. Do the below in the ApplicationController to have it available on all pages.
```ruby
before_filter :load_menu
def load_menu
  @menu = Burp::Menu.find("main")
end
```
    
## Global content like footers/headers

There is curently no builtin solution for this. Until we add this one can use the solution below to get the same as global snippets.

Add this to application_controller
```ruby
helper_method :global_snippets
def global_snippets
  @global_snippets ||= Burp.find_page("/global-snippets") || Burp::Page.new(:snippets => {}, :title => "Not a real page, Dont remove!", :page_id => "/global-snippets")
end
```

and use it like this in your views.

```erb
<html>
  <body>
    <header>
      <%= global_snippets[:header] %>
    </header>
    <footer>
      <%= global_snippets[:footer] %>
    </footer>
  </body>
</html>
```

## Changes

**1.7.1**

- Fixed so that dependancy on jquery-ui-rails set to the correct version.

## Contributing
* Fork the project
* Send a pull request
* Don't touch the .gemspec, I'll do that when I release a new version

## Copyright

Copyright (c) 2012 - 2015 Björn Blomqvist. See LICENSE.txt (LGPL) for further details.
