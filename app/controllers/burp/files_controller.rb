# encoding: UTF-8
require 'fileutils'

module Burp
  class FilesController < Burp::ApplicationController
    
    skip_before_filter :authenticate, :only => [:show]
    
    def index
      
      access.may_view_file_list! do
      
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
        Util.remove_all_versions_of_image(file_path)
      end
      
      Util.commit("Burp: removed a file")
      
      redirect_to files_path, notice: "#{File.basename(file_path)} has been removed."
    end
    
    def show
      file_path = "#{upload_directory_path}#{params[:id]}#{params[:format].blank? ? "" : ".#{params[:format]}"}"
      
      if File.expand_path(file_path) != file_path
        render :text => "403, Forbiden!", :status => 403, :content_type => "text/plain"
      elsif File.exist?(file_path)
        access.may_view_file!(file_path) do
          
          headers["Cache-Control"] = "Public"
          headers["Last-Modified"] = File.mtime(file_path).utc.rfc2822
          
          # Stop session cookie form being set
          request.session_options[:skip] = true 
          
          send_file(file_path, :disposition => disposition(file_path))
        end
      else  
        render :text => "404, No such file", :status => 404, :content_type => "text/plain"
      end

    end
    
    def create 
      access.may_upload_a_file! do
        Util::UploadHandler.handle(params[:qqfile],request) do |file|
        
          errors = []
          errors << {:size => "File to big, max size is 40 meg"} if file.size > 40.megabyte
        
          if errors.length > 0
            render :json => {:errors => errors}
          else
            target_path = upload_directory_path + make_url_safe(File.basename(file.path))
            
            FileUtils.mkdir_p(upload_directory_path)
            FileUtils.mv(file.path, target_path)
            FileUtils.chmod(0644, target_path)
            
            Burp::Util.create_smaller_images(target_path) if target_path.match(/(jpg|jpeg|gif|png)$/i)
            
            Util.commit("Burp: file upload", :path => upload_directory_path)
            render :json => {:success => true}
          end
        end
      end
      
    end
    
    private
    
    FROM_CHARACTERS = " ÀÁÂÃàáâãÇçĆćČčÐðÈÉÊËèéêëÌÍÎÏìíîïŁłÑñŃńÒÓÔòóôŘřŚśšÙÚÛùúûÜÝüýÅåÄÆäæÖØöø"
    TO_CHARACTERS   = "-AAAAaaaaCcCcCcDdEEEEeeeeIIIIiiiillNnNnOOOoooRrSssUUUuuuUYuyAaAAaaOOoo"
    OTHER = "̌̀̂́̊̈ ̃ ̧"
    
    def make_url_safe(file_name)
      file_name.chars.map do |char|
        i = FROM_CHARACTERS.index(char)
        i ? TO_CHARACTERS[i] : (OTHER.include?(char) ? "" : char)
      end.join('')
    end
    
    def disposition(file_path)
      file_path.match(/\.(png|jpeg|gif|jpg|pdf|txt)$/) && !params.has_key?(:download) ? 'inline' : 'attachment'
    end
    
    def upload_directory_path
      "#{Burp.content_directory}uploads/"
    end
    
  end
end