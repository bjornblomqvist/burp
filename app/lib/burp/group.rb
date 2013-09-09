
module Burp
  class Group
  
    attr_reader :id
    attr_accessor :children
    attr_accessor :name
  
    def initialize(name,options = {})
      @name = name
      @children = (options[:children] || options['children']) || []
    end

    def to_html(request = nil)
      
      if first_link
        first_link_in_group = %{<span class="first-link-in-group #{first_link.current_class(request)}">#{first_link.to_html(request,name)}</span>}
      else
        first_link_in_group = ""
      end
      
      
      %{
      <section #{id ? "id='#{id}'" : ""} class="group"><span class="group-name">#{name}</span>
        #{first_link_in_group}
        <ul class="children">
          #{children.inject("") do |x,link|  x += "<li class=\"child #{link.is_a?(Group) ? "group" : "link" } #{link.current_class(request)}\">#{link.to_html(request)}</li>" end}
        </ul>
      </section>
      }.html_safe      
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
    
    def to_menu
      menu = Menu.new(self.name)
      menu.children = Group.from_yaml(self.to_yaml).children
      
      menu
    end
    
    def links
      children.map {|child| child.is_a?(Group) ? child.links : child}.flatten
    end
    
    def to_param
      id
    end
    
    def update_id(parent_id)
      @id = {:parent_id => parent_id, :hash => self.hash}.hash
      children.each_with_index do |child,index|
        child.update_id("#{self.id}#{index}")
      end
    end
    
    def all_children
      children+children.map do |child|
        child.is_a?(Group) ? child.all_children : nil
      end.flatten.compact
    end
    
    
    
    def <=>(other)
      other.is_a?(Group) || other.is_a?(Link) ? name <=> other.name : 0
    end

    def eql?(other)
      self.class == other.class && self.hash == other.hash
    end

    def hash
      to_hash.hash
    end
    
    def self.bootstrap_nav(group)
      %{
      <ul class="nav">
        #{group.children.map { |child| child.is_a?(Link) ? "<li class=\"#{child.css_class}\">#{child.to_html}</li>" : "" }.join("\n\t\t\t")}
      </ul>
      }.html_safe
    end
    
  end
end