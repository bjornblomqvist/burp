module Burp
  class LinksController < ApplicationController
    
    def new
      @menu = Menu.find(params[:menu_id])
      @link = nil
      
      render :action => :edit
    end
    
    def create
      @menu = Menu.find(params[:menu_id])
      @menu.children << Link.new(params[:link][:name] => params[:link][:url])
      @menu.save
    
      redirect_to edit_menu_path(@menu)
    end
    
  end
end