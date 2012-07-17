module Burp
  

  class Page 

    attr_accessor :snippets,:title,:link_tree

    def initialize(snippets = {},title = "",link_tree)
      @snippets = snippets
      @title = title
      @link_tree  = link_tree || Group.new("root")
    end

    def [](location_name)
      ("<!-- snippet data-type=\"start\" data-name=\"#{location_name}\" -->"+(@snippets[location_name.to_sym] || "<h2>#{location_name.to_s}</h2>")+"<!-- snippet data-type=\"end\" data-name=\"#{location_name}\" -->").html_safe
    end

    def []=(location_name,value)
      @snippets[location_name.to_sym] = value
    end

  end

end