module Burp
  

  class Page 

    attr_accessor :snippets, :title, :page_id

    def initialize(options = {})
      @snippets = options[:snippets] || {}
      @title = options[:title] || ""
      @page_id = options[:page_id] || ""
    end

    def [](location_name)
      ("<!-- snippet data-type=\"start\" data-page-id=\"#{page_id}\" data-name=\"#{location_name}\" -->"+(@snippets[location_name.to_sym] || "<h2>#{location_name.to_s}</h2>")+"<!-- snippet data-type=\"end\" data-name=\"#{location_name}\" -->").html_safe
    end

    def []=(location_name,value)
      @snippets[location_name.to_sym] = value
    end

  end

end