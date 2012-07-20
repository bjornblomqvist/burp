
require 'fileutils'

module Burp
  class FileController < ApplicationController
    
    def index
      @file_paths  = Dir.glob("#{Burp.upload_directory}**/*")
    end
    
    def create 
      
      Util::UploadHandler.handle(params[:qqfile],request) do |file|
        
        errors = []
        errors << {:size => "File to big, max size is 15meg"} if file.size > 15.megabyte
        
        if errors.length > 0
          render :json => {:errors => errors}
        else
          FileUtils.mv(file.path,Burp.upload_directory+File.basename(file.path))
          render :json => {:success => true}
        end
      end
      
    end
    
  end
end