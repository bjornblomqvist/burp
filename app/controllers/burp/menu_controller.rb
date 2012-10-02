module Burp
  class MenuController < Burp::ApplicationController
    def update
      menu = Group.from_hash(JSON.parse(params[:menu])).to_menu(params[:id]+".yaml")
      menu.save
      
      render :json => {:success => true}
    end 
  end
end