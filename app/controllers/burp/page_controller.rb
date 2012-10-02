module Burp
  class PageController < Burp::ApplicationController
    def index
      Burp.access.may_view_page_list! do
        @menu = Burp::Menu.find("menu.yaml")
      end
    end
    
    def edit
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
      Burp.access.may_edit_page!(@page) do    
          
        respond_to do |format|
          format.html {}
          format.json { render :json =>  @page }
        end
      end
    end
    
    def show
      path = ("/"+params[:id]).gsub("/$root","/")
      @page = PageModel.find(path)
      Burp.access.may_view_page_data!(@page) do

        respond_to do |format|
          format.html {
            redirect_to path
          }
          format.json { render :json =>  @page }
        end
      end
    end
    
    def new
      @page = PageModel.new
      Burp.access.may_create_new_page! do
        render :action => :edit
      end
    end
    
    def create
      
      Burp.access.may_create_new_page! do
        
        @page = PageModel.new
  
        @page.title = params[:page][:title]
        @page.path = params[:page][:path]
        @page.link_label = params[:page][:link_label]
        (params[:page][:snippets] || {}).each do |name,value|
          @page.snippets[name] = value
        end
        @page.save
      
        respond_to do |format|
          format.html {
            redirect_to "/burp/pages/"
          }
          format.json { render :json =>  {:success => true} }
        end
      end
    end
    
    def update
      
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/")) || PageModel.new(:path => ("/"+params[:id]).gsub("/$root","/"))
      Burp.access.may_update_page!(@page) do
  
        @page.title = params[:page][:title] if params[:page][:title]
        @page.path = params[:page][:path] if params[:page][:path]
        @page.misc = params[:page][:misc] if params[:page][:misc]
        @page.link_label = params[:page][:link_label] if params[:page][:link_label]
        @page.snippets = {}
        (params[:page][:snippets] || {}).each do |name,value|
          @page.snippets[name] = value
        end
        @page.save
      
        respond_to do |format|
          format.html {
            redirect_to "/burp/pages/"
          }
          format.json { render :json =>  {:success => true} }
        end
      end
      
    end
    
    def destroy
      
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
      Burp.access.may_remove_page!(@page) do
        
        @page.remove
        redirect_to "/burp/pages/"
      end
    end
    
  end
  
end