module Burp
  class Link
    
    attr_reader :id
    attr_accessor :url,:name
    attr_accessor :css_class

    def initialize(options)      
      self.name ||= options[:name]
      self.url ||= options[:url]
      self.css_class ||= options[:class]
      
      self.name ||= options.keys.first
      self.url ||= options.values.first
      
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
      %{<a class="#{current_class(request)} #{css_class}" #{id ? "id='#{id}'" : ""} href="#{url}">#{name || self.name}</a>}.html_safe
    end
    
    def to_param
      id
    end
    
    def self.from_yaml(yaml)
      from_hash(YAML::load(yaml))
    end

    def self.from_hash(hash)
      Link.new((hash[:name] || hash['name']) => (hash[:url] || hash['url']))
    end
    
    def to_hash
      {:name => name, :url => url}
    end

    def to_yaml
      to_hash.to_yaml
    end
    
    
    def update_id(parent_id)
      @id = {:parent_id => parent_id, :hash => self.hash}.hash
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
    
  end
end