module Burp
  class MenusController < Burp::ApplicationController
    
    def index
      @menus = Menu.all
    end
    
    def edit
      @menu = Menu.find(params[:id])
      @menu.update_id("")
    end
    
    def update
      menu = Group.from_hash(JSON.parse(params[:menu])).to_menu(params[:id]+".yaml")
      menu.save
      
      render :json => {:success => true}
    end 
    
  end
end