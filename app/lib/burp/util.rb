
require 'fileutils'
require 'RMagick'

module Burp
  module Util
  
    def self.commit(message = "auto commit")
      raise "missing git repo in burp cms directory" unless File.exist?("#{Burp.content_directory}/.git")
      `cd #{Burp.content_directory}; git add .; git commit -a -m "Burp: #{message}"`
    end
    
    def self.create_smaller_images(file_path)
      
      upload_directory_path = "#{Burp.content_directory}uploads/"
      
      sizes = {:small => [200,300],:medium => [600,900], :large => [1000,1500]}
      image = Magick::ImageList.new(file_path).first
      image.auto_orient!
      
      sizes.each_pair do |key,value|
        
        FileUtils.mkdir_p("#{upload_directory_path}#{key.to_s}")
        target_path = "#{upload_directory_path}#{key.to_s}/#{File.basename(file_path)}"
        
        if value[0] < image.columns # We only downscale
          image.resize_to_fit(value[0],value[1]).write(target_path) { self.quality = 75 }
        else
          File.unlink(target_path) if File.exist?(target_path)
          File.symlink("../#{File.basename(file_path)}",target_path)
        end
      end
      image.destroy!
    end
    
    
    
  end
end