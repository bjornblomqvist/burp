module Burp
  
  class PageController < ApplicationController
    def index
      @pages = PageModel.all.sort {|a,b| a.path <=> b.path}
    end
    
    def edit
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
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
      
      redirect_to "/burp/pages/"
      
    end
    
    def update
      
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
  
      @page.title = params[:page][:title]
      @page.path = params[:page][:path]
      @page.link_label = params[:page][:link_label]
      @page.snippets = {}
      (params[:page][:snippets] || {}).each do |name,value|
        @page.snippets[name] = value
      end
      @page.save
      
      redirect_to "/burp/pages/"
      
    end
    
    def destroy
      
      @page = PageModel.find(("/"+params[:id]).gsub("/$root","/"))
      @page.remove
      
      redirect_to "/burp/pages/"
    end
    
  end
  
end