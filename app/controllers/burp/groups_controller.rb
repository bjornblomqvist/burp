class Burp::GroupsController < Burp::ApplicationController
  
  def edit
    @menu = Burp::Menu.find(params[:menu_id])
    @menu.update_id("")
    @group = @menu.all_children().select {|child| child.id.to_s == params[:id].to_s}.first
  end
  
  def update
    @menu = Burp::Menu.find(params[:menu_id])
    @menu.update_id("")
    @group = @menu.all_children().select {|child| child.id.to_s == params[:id].to_s}.first
    @group.name = params[:group][:name]
    @menu.save
    
    redirect_to edit_menu_path(@menu)
  end
  
end