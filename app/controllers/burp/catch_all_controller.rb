
module Burp
  
  class CatchAllController < ApplicationController
  
    def show
      @cms_page = Burp::TestCMS.cms_page(request.path)
      
      render :text => @cms_page[:main], :layout => 'application'
    end

    def cms_page
      @cms_page
    end
    
    helper_method :cms_page
  
  end
  
end