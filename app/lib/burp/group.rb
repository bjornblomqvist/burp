
module Burp
  class Group
  
    attr_accessor :children
    attr_accessor :name
  
    def initialize(name,options = {})
      @name = name
      @children = (options[:children] || options['children']) || []
    end

    def to_html(request = nil)
      if children.length > 0
        %{
        <section class="group">
          <h2 class="group-name">#{name}</h2>
          <h2 class="first-link-in-group #{first_link ? first_link.current_class(request) : ""}">#{first_link ? first_link.to_html(request) : ""}</h2>
          <ul class="children">
          #{children.inject("") do |x,link|  x += "<li class=\"child #{link.is_a?(Group) ? "group" : "link" } #{link.current_class(request)}\">#{link.to_html(request)}</li>" end}
          </ul>
        </section>
        }.html_safe      
      else
        ""
      end
    end
  
    def current?(request = nil)
      children.each do |child|
        return true if child.current?(request)
      end
      false
    end

    def current_class(request = nil)
      "current-section" if current?(request)
    end
    
    def first_link
      children.select {|v| v.is_a? Link}.first
    end
    
    def self.from_yaml(yaml)
      from_hash(YAML.load(yaml))
    end
    
    def self.from_hash(hash)
      group = Group.new((hash[:name] || hash['name']),hash)
      group.children.map!{|child| (child[:url] || child['url']) ? Link.from_hash(child) : Group.from_hash(child)}
      
      group
    end
    
    def to_hash
      {:name => name, :children => children.map{|child| child.to_hash}}
    end
    
    def to_yaml
      to_hash.to_yaml
    end
    
    def to_menu(file_name)
      menu = Menu.new(file_name)
      menu.name = self.name
      menu.children = Group.from_yaml(self.to_yaml).children
      
      menu
    end
    
    def links
      children.map {|child| child.is_a?(Group) ? child.links : child}.flatten
    end
  end
end