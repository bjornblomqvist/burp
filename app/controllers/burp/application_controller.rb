module Burp
  class ApplicationController < ActionController::Base
    
    protect_from_forgery
    before_filter :refresh_access
    before_filter :authenticate
    before_filter :set_site
    before_filter :init_body_classes
    
    def init_body_classes 

      module_name = self.class.parent.class == Module ? self.class.parent.name+"-" : ""

      @body_classes ||= ""
      @body_classes += " #{module_name}#{controller_name} ".downcase
      @body_classes += " #{module_name}#{controller_name}-#{action_name} ".downcase

      @body_classes += " #{(request.user_agent || '').match(/(lion)/i) ? "noscrollbars" : "scrollbars"} "
    end
    
    private
    
    def refresh_access
      Burp.access.refresh
    end
    
    def set_site
      Thread.current[:burp_current_content_directory] = current_site.site_content_directory
    end
    
    def current_site
      @current_site_cache ||= Site.find(request.host) || Burp::Site.default
    end
    
    def authenticate
      unless Burp.access.may_skip_http_auth? || Rails.env = "test"
      
        if !Rails.application.config.respond_to?(:burp_password) or !Rails.application.config.respond_to?(:burp_username)
          raise "config.burp_username and config.burp_password are not set.\n\nYou can fix this by adding them to application.rb."
        end
      
        unless Rails.env == 'development'
          authenticate_or_request_with_http_basic do |username, password|
            # Rails.logger.debug "in authenticate_or_request_with_http_basic, #{request.headers['Authorization']}"
            username == Rails.application.config.burp_username && password == Rails.application.config.burp_password
          end
        end
      
      end
    end
    
  end
end
    
