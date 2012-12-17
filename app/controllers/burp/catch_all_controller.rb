
module Burp
    
  class CatchAllController < ApplicationController

    def show
      @menu = Burp::Menu.find("main")
      @cms_page = Burp.find_page(request.path)
      Burp.access.refresh
      Burp.access.may_view_page!(@cms_page)

      raise ActionController::RoutingError.new('Page not Found') if @cms_page.nil?

      render :text => @cms_page[:main], :layout => "application"
    end

    def cms_page
      @cms_page
    end

    helper_method :cms_page

  end
  
end