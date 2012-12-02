
module Burp
  class GroupsController < Burp::ApplicationController
  
    def edit
      @menu = Menu.find(params[:menu_id])
      @menu.update_id("")
      @group = @menu.all_children().select {|child| child.id.to_s == params[:id].to_s}.first
    end
  
    def update
      @menu = Menu.find(params[:menu_id])
      @menu.update_id("")
      @group = @menu.all_children().select {|child| child.id.to_s == params[:id].to_s}.first
      @group.name = params[:group][:name]
      @menu.save
    
      redirect_to edit_menu_path(@menu)
    end
    
    def destroy
      @menu = Menu.find(params[:menu_id])
      @menu.update_id("")
      @group_to_remove = @menu.all_children().select {|child| child.id.to_s == params[:id].to_s}.first
      @group = (@menu.all_children+[@menu]).select {|child| child.is_a?(Group) && child.children.include?(@group_to_remove)}.first
      @group.children.delete(@group_to_remove)
      @menu.save
    
      redirect_to edit_menu_path(@menu)
    end
  
  
    def new
      @menu = Menu.find(params[:menu_id])
      @group = nil
      
      render :action => :edit
    end
  
    def create
      @menu = Menu.find(params[:menu_id])
      @menu.children << Group.new(params[:group][:name])
      @menu.save
    
      redirect_to edit_menu_path(@menu)
    end
  
  end
end