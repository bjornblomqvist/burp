
require 'fileutils'

module Burp
  class FilesController < Burp::ApplicationController
    
    skip_before_filter :authenticate, :only => [:show]
    
    def index
      
      Burp.access.may_view_file_list! do
      
        @files = FileModel.all
      
        respond_to do |format|
          format.html {}
          format.json { render :json =>  {:paths => @files.map {|file| file.public_path }} }
        end
      end
    end
    
    def destroy
      file_path = "#{upload_directory_path}#{params[:id].gsub("burp/files/","")}#{params[:format].blank? ? "" : ".#{params[:format]}"}"
      
      if File.expand_path(file_path) != file_path
        render :text => "403, Forbiden!", :status => 403, :content_type => "text/plain"
      else
        File.unlink(file_path)
      end
      
      Util.commit("Burp: removed a file")
      
      redirect_to files_path
    end
    
    def show
      file_path = "#{upload_directory_path}#{params[:id]}#{params[:format].blank? ? "" : ".#{params[:format]}"}"
      
      if File.expand_path(file_path) != file_path
        render :text => "403, Forbiden!", :status => 403, :content_type => "text/plain"
      elsif File.exist?(file_path)
        Burp.access.may_view_file!(file_path) do
          
          headers["Cache-Control"] = "Public"
          headers["Last-Modified"] = File.mtime(file_path).utc.rfc2822
          
          # Stop session cookie form being set
          request.session_options[:skip] = true 
          
          # WTF, send_file does not set content-length on HEAD request
          headers["X-Burp-file-size"] = File.size(file_path).to_s
          
          # Send image size
          if request.method == 'HEAD' && file_path.match(/\.(png|jpeg|gif|jpg)$/)
            headers["X-Burp-image-size"] = Burp::Util.image_size(file_path)
          end
          
          send_file(file_path, :disposition => disposition(file_path))
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
            FileUtils.mkdir_p(upload_directory_path)
            FileUtils.mv(file.path,upload_directory_path+File.basename(file.path))
            
            Burp::Util.create_smaller_images(upload_directory_path+File.basename(file.path)) if file.path.match(/(jpg|jpeg|gif|png)$/i)
            
            Util.commit("Burp: file upload")
            render :json => {:success => true}
          end
        end
      end
      
    end
    
    private
    
    def disposition(file_path)
      file_path.match(/\.(png|jpeg|gif|jpg|pdf|txt)$/) && !params.has_key?(:download) ? 'inline' : 'attachment'
    end
    
    def upload_directory_path
      "#{Burp.content_directory}uploads/"
    end
    
  end
end