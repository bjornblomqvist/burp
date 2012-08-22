module Burp
  class ApplicationController < ActionController::Base
    
    protect_from_forgery
    before_filter :authenticate
    
    private
    
    def authenticate
      
      if !Rails.application.config.respond_to?(:burp_password) or !Rails.application.config.respond_to?(:burp_username)
        raise "config.burp_username and config.burp_password are not set.\n\nYou can fix this by adding them to application.rb."
      end
      
      unless Rails.env == 'development'
        authenticate_or_request_with_http_basic do |username, password|
          username == Rails.application.config.burp_username && password == Rails.application.config.burp_password
        end
      end
    end
    
  end
end
    
