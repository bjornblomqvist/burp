module Burp
  class StaticController < Burp::ApplicationController
    def index
      Burp.access.may_view_static_page!(params[:action])
    end 
    
    def basic
      
    end
  end
end