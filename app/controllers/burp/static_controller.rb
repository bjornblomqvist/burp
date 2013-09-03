module Burp
  class StaticController < Burp::ApplicationController
    def index
      access.may_view_static_page!(params[:action])
    end 
    
    def help
      
    end
  end
end