module Burp
  class LinksController < ApplicationController
    
    def new
      @menu = Menu.find(params[:menu_id])
      @link = nil
      
      render :action => :edit
    end
    
    def edit
      @menu = Menu.find(params[:menu_id])
      @menu.update_id("")
      @link = @menu.all_children().select {|child| child.id.to_s == params[:id].to_s}.first
    end
    
    def update
      @menu = Menu.find(params[:menu_id])
      @menu.update_id("")
      @link = @menu.all_children().select {|child| child.id.to_s == params[:id].to_s}.first
      @link.name = params[:link][:name]
      @link.url = params[:link][:url]
      @menu.save
    
      redirect_to edit_menu_path(@menu)
    end
    
    def destroy
      @menu = Menu.find(params[:menu_id])
      @menu.update_id("")
      @link = @menu.all_children().select {|child| child.id.to_s == params[:id].to_s}.first
      @group = (@menu.all_children+[@menu]).select {|child| child.is_a?(Group) && child.children.include?(@link)}.first
      @group.children.delete(@link)
      @menu.save
    
      redirect_to edit_menu_path(@menu)
    end
    
    def create
      @menu = Menu.find(params[:menu_id])
      @menu.children << Link.new(params[:link][:name] => params[:link][:url])
      @menu.save
    
      redirect_to edit_menu_path(@menu)
    end
    
  end
end