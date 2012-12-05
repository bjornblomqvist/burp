module Burp
  class MenusController < Burp::ApplicationController
    
    def index
      @menus = Menu.all
    end
    
    def edit
      @menu = Menu.find(params[:id])
      @menu.update_id("")
      
      all_items = @menu.all_children
      
      @pages_not_in_menu = Group.new("pages not in menu")
      
      PageModel.all_paths.each do |path|
        path2 = path == "/" ? path : path + "/"
        if(all_items.select{|item| item.is_a?(Link) && (item.url == path || item.url == path2)}.length == 0) 
          page = PageModel.find(path)
          @pages_not_in_menu.children << Link.new(page.title => page.path)
        end
      end
    end
    
    def update
      menu = Group.from_hash(JSON.parse(params[:menu])).to_menu
      menu.save
      
      render :json => {:success => true}
    end 
    
  end
end