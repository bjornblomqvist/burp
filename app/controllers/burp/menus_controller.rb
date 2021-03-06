module Burp
  class MenusController < Burp::ApplicationController
    
    def index
      @menus = Menu.all
    end
    
    def edit
      @menu = Menu.find(params[:id])
      @menu.update_id("")
      
      render :layout => false if params[:no_layout]
    end
    
    def update
      menu = Group.from_hash(JSON.parse(params[:menu])).to_menu
      menu.save
      
      render :json => {:success => true}
    end 
    
  end
end