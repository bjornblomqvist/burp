
module Burp
  class Group
  
    attr_accessor :children
    attr_reader :name
  
    def initialize(name,options = {})
      @name = name
      @children = options[:children] || []
    end
  
  
  
  
  
  
  
  
  
  
    def first_link
      children.select {|v| v.is_a? Link}.first
    end
  
    def to_html(request = nil)
      if children.length > 0
      
        if name == "root"
          %{
            <section class="root">
            #{children.inject("") do |x,child|  x += "#{child.to_html(request)}" end}
            </section>
          }.html_safe
        else  
          %{
          <section class="group">
            <h2 class="group-name">#{name}</h2>
            <h2 class="first-link-in-group">#{first_link ? first_link.to_html : ""}</h2>
            <ul class="children">
            #{children.inject("") do |x,link|  x += "<li class=\"child #{link.current_class(request)}\">#{link.to_html(request)}</li>" end}
            </ul>
          </section>
          }.html_safe      
        end
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

  

  

  
  end
end