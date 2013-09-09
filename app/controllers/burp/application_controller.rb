module Burp
  class ApplicationController < ActionController::Base
    
    protect_from_forgery
    before_filter :authenticate
    before_filter :init_body_classes
    
    def init_body_classes 

      module_name = self.class.parent.class == Module ? self.class.parent.name+"-" : ""

      @body_classes ||= ""
      @body_classes += " #{module_name}#{controller_name} ".downcase
      @body_classes += " #{module_name}#{controller_name}-#{action_name} ".downcase

      @body_classes += " #{(request.user_agent || '').match(/(lion)/i) ? "noscrollbars" : "scrollbars"} "
    end
    
    helper_method :menu
    def menu
      group = Group.new("") 
      group.children << Link.new(:name => "Pages", :url => "/burp/pages")
      if Burp::Menu.count == 1
        group.children << Link.new(:name => "Menu", :url => burp_engine.edit_menu_path(Burp::Menu.all.first))
      else
        group.children << Link.new(:name => "Menus", :url => "/burp/menus")
      end
      group.children << Link.new(:name => "Files", :url => "/burp/files")
      group.children << Link.new(:name => "Help", :url => "/burp/herp", :class => "markdown")
      
      group
    end
    
    private
    
    def access
      @access ||= Burp.new_access_instance(request, self)
    end
    
    def authenticate
      unless access.may_skip_http_auth? || Rails.env == "test"
      
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
    
