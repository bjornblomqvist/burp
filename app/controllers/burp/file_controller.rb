
require 'fileutils'

module Burp
  class FileController < Burp::ApplicationController
    
    skip_before_filter :authenticate, :only => [:show]
    
    def index
      
      Burp.access.may_view_file_list! do
      
        @file_paths = Dir.glob("#{Burp.upload_directory}**/*")
        @file_paths = @file_paths.sort {|p1,p2| File.mtime(p2) <=> File.mtime(p1)}
        @file_paths = @file_paths.map {|path| path.gsub("#{Burp.upload_directory}","/burp/files/") }
      
        respond_to do |format|
          format.html {}
          format.json { render :json =>  {:paths => @file_paths} }
        end
      end
    end
    
    def show
      file_path = "#{Burp.upload_directory}#{params[:id]}#{params[:format].blank? ? "" : ".#{params[:format]}"}"
      
      if File.expand_path(file_path) != file_path
        render :text => "403, Forbiden!", :status => 403, :content_type => "text/plain"
      elsif File.exist?(file_path)
        Burp.access.may_view_file!(file_path) do
          send_file(file_path,:disposition => file_path.match(/png|jpeg|gif|jpg|pdf/) ? 'inline' : 'attachment')
        end
      else  
        render :text => "404, No such file", :status => 404, :content_type => "text/plain"
      end

    end
    
    def create 
      Burp.access.may_upload_a_file! do
        Util::UploadHandler.handle(params[:qqfile],request) do |file|
        
          errors = []
          errors << {:size => "File to big, max size is 15meg"} if file.size > 15.megabyte
        
          if errors.length > 0
            render :json => {:errors => errors}
          else
            FileUtils.mkdir_p(Burp.upload_directory)
            FileUtils.mv(file.path,Burp.upload_directory+File.basename(file.path))
            `cd #{Burp.upload_directory}; git add .; git commit -a -m "cms autocommit file upload"`
            render :json => {:success => true}
          end
        end
      end
      
    end
    
  end
end