module Burp
  
  class PageController < ApplicationController
    def index
      @pages = PageModel.all.sort {|a,b| a.path <=> b.path}
    end
    
    def edit
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
      
      respond_to do |format|
        format.html {}
        format.json { render :json =>  @page }
      end
    end
    
    def show
      path = ("/"+params[:id]).gsub("/$root","/")
      
      @page = PageModel.find(path)

      respond_to do |format|
        format.html {
          redirect_to path
        }
        format.json { render :json =>  @page }
      end
    end
    
    def new
      @page = PageModel.new
      render :action => :edit
    end
    
    def create
      
      @page = PageModel.new
  
      @page.title = params[:page][:title]
      @page.path = params[:page][:path]
      @path.link_label = params[:page][:link_label]
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
    
    def update
      
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
  
      @page.title = params[:page][:title]
      @page.path = params[:page][:path]
      @page.misc = params[:page][:misc]
      @page.link_label = params[:page][:link_label]
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
    
    def destroy
      
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
      @page.remove
      
      redirect_to "/burp/pages/"
    end
    
  end
  
end