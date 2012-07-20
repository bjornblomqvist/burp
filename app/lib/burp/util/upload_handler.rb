
require 'fileutils'

module Burp
  module Util

    class UploadHandler
  
      def self.handle file_or_file_name,request
    
        tempfile = handle_raw_data(file_or_file_name,request)
    
        shasum = `shasum #{tempfile.path}`.match(/^([0-9a-f]{40})/i)[1]
        new_dir = "/tmp/#{shasum}_#{Time.now.to_i}/"
        new_path = "#{new_dir}#{tempfile.original_filename}"  
    
      
        Dir.mkdir(new_dir)
        FileUtils.mv(tempfile.path,new_path)
    
        tempfile.close(true)
    
        yield(UploadedFile.new(new_path,shasum))
      ensure
        File.unlink(new_path) if new_path && File.exist?(new_path)
        Dir.rmdir(new_dir) if new_dir && File.exist?(new_dir)
      end
  
      class UploadedFile
    
        def initialize path,shasum
          @path = path
          @shasum = shasum
        end
    
        def path
          @path
        end
    
        def size 
          File.size(self.path)
        end
    
        def sha1sum
          @shasum
        end
    
      end
  
  
      # http://github.com/valums/file-uploader
      def self.handle_raw_data tempfile,request
        if tempfile.is_a? String
      
      
          file = Tempfile.new('foo',:encoding => 'ascii-8bit')
          while s = request.env['rack.input'].read(16*1024)
            file.write(s)
          end
          file.flush
      
          def file.original_filename
            @file_name
          end
    
          def file.tempfile 
            self
          end
    
          def file.original_filename= value
            @file_name = value
          end
    
          file.original_filename = File.basename(tempfile)
    
          file
        else
          tempfile
        end
      end
  
    end
  end
end
