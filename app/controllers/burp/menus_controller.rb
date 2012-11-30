module Burp
  class MenusController < Burp::ApplicationController
    
    def edit
      @menu = Menu.find(params[:id])
      @menu.update_id("")
    end
    
    def update
      menu = Group.from_hash(JSON.parse(params[:menu])).to_menu(params[:id]+".yaml")
      menu.save
      
      render :json => {:success => true}
    end 
    
    
    def new_group
      @menu = Menu.find(params[:id])
      @group = nil
    end
    
    def create_group
      @menu = Menu.find(params[:id])
      @menu.children << Group.new(params[:group][:name])
      @menu.save
      
      redirect_to edit_menu_path(@menu)
    end
    
  end
end