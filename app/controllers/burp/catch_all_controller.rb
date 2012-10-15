
module Burp
  
  class CatchAllController < Burp::ApplicationController
    
    skip_before_filter :authenticate, :only => [:show]
  
    def show
      site = Burp::Site.find(request.headers['host']) || Burp::Site.default

      @cms_page = site.find_page(request.path)
      Burp.access.may_view_page!(@cms_page)
      
      render :text => @cms_page[:main], :layout => 'application'
    end

    def cms_page
      @cms_page
    end
    
    helper_method :cms_page
  
  end
  
end