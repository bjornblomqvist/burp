module Burp
  class Link

    attr_accessor :url,:name

    def initialize(options)
      self.name = options.keys.first
      self.url = options.values.first

      raise ArgumentError.new("Missing a url") unless url
      raise ArgumentError.new("Missing a name") unless name
    end




    def current?(request = nil)
      request && request.path == url
    end

    def current_class(request = nil)
      current?(request) ? "current-url" : ""
    end

    def to_html(request = nil,name = nil)
      %{<a class="#{current_class(request)}" href="#{url}">#{name || self.name}</a>}.html_safe
    end

  end
end