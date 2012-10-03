module Burp
  class Site
    
    attr_accessor :domain_name
    
    def initialize(domain_name = "default")
      @domain_name = domain_name
    end
    
    def content_directory
      "#{Burp.content_directory}#{domain_name}/"
    end
    
    def upload_directory
      content_directory+"uploads/".to_s
    end
    
  end
end