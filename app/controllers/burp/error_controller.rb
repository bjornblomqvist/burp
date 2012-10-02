module Burp
  class ErrorController < Burp::ApplicationController
    def no_such_page
      raise ActionController::RoutingError.new('Not Found')
    end 
  end
end