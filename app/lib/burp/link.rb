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
    
    def self.from_yaml(yaml)
      from_hash(YAML::load(yaml))
    end

    def self.from_hash(hash)
      Link.new(hash[:name] => hash[:url])
    end
    
    def to_hash
      {:name => name, :url => url}
    end

    def to_yaml
      to_hash.to_yaml
    end
  end
end