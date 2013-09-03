module Burp
  class PagesController < Burp::ApplicationController

    def index
      access.may_view_page_list! do
        @pages = PageModel.all
      end
    end
    
    def edit
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
      access.may_edit_page!(@page) do    
          
        respond_to do |format|
          format.html {}
          format.json { render :json =>  @page }
        end
      end
    end
    
    def show
      path = ("/"+params[:id]).gsub("/$root","/")
      @page = PageModel.find(path)
      access.may_view_page_data!(@page) do

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
      access.may_create_new_page! do
        render :action => :edit
      end
    end
    
    def create
      
      access.may_create_new_page! do
        
        @page = PageModel.new
        
        @page.title = params[:page][:title]
        @page.path = params[:page][:path]
        (params[:page][:snippets] || {}).each do |name,value|
          @page.snippets[name] = value
        end
        
        if @page.save
      
          respond_to do |format|
            format.html {
              redirect_to pages_path
            }
            format.json { render :json =>  {:success => true} }
          end
        else
          respond_to do |format|
            format.html {
              render :edit
            }
            format.json { render :json =>  {:errors => @page.errors} }
          end
        end
      end
    end
    
    def update
      
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/")) || PageModel.new(:path => ("/"+params[:id]).gsub("/$root","/"))
      access.may_update_page!(@page) do
  
        @page.title = params[:page][:title] if params[:page][:title]
        @page.path = params[:page][:path] if params[:page][:path]
        
        if params[:page][:snippets]
          @page.snippets = {}
          (params[:page][:snippets] || {}).each do |name,value|
            @page.snippets[name] = value
          end
        end
        
        @page.save
          
        respond_to do |format|
          format.html {
            redirect_to pages_path
          }
          format.json { render :json =>  {:success => true} }
        end
      end
    end
    
    def destroy
      
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
      access.may_remove_page!(@page) do
        
        @page.remove
        redirect_to "/burp/pages/"
      end
    end
    
  end
  
end