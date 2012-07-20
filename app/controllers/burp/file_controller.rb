
require 'fileutils'

module Burp
  class FileController < ApplicationController
    
    def index
      
      @file_paths  = Dir.glob("#{Burp.upload_directory}**/*").map {|path| path.gsub("#{Burp.upload_directory}","/burp/files/") }
      
      respond_to do |format|
        format.html {}
        format.json { render :json =>  {:paths => @file_paths} }
      end
    end
    
    def show
      file_path = "#{Burp.upload_directory}#{params[:id]}#{params[:format].blank? ? "" : ".#{params[:format]}"}"
      
      if File.expand_path(file_path) != file_path
        render :text => "403, Forbiden!", :status => 403, :content_type => "text/plain"
      elsif File.exist?(file_path)
        send_file(file_path,:disposition => file_path.match(/png|jpeg|gif|jpg|pdf/) ? 'inline' : 'attachment')
      else  
        render :text => "404, No such file", :status => 404, :content_type => "text/plain"
      end

    end
    
    def create 
      
      Util::UploadHandler.handle(params[:qqfile],request) do |file|
        
        errors = []
        errors << {:size => "File to big, max size is 15meg"} if file.size > 15.megabyte
        
        if errors.length > 0
          render :json => {:errors => errors}
        else
          FileUtils.mkdir_p(Burp.upload_directory)
          FileUtils.mv(file.path,Burp.upload_directory+File.basename(file.path))
          render :json => {:success => true}
        end
      end
      
    end
    
  end
end