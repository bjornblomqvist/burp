
class Burp::CatchAllController < ApplicationController

  skip_before_filter :authenticate

  def show
    @menu = Burp::Menu.find("main")
    @burp_page_path = params[:burp_page_path] || request.path
    @cms_page = Burp.find_page(@burp_page_path)
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
