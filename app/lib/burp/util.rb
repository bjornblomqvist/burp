
require 'fileutils'
require 'RMagick'

module Burp
  module Util
  
    SIZES = {:small => [200,300],:medium => [600,900], :large => [1000,1500]}
  
    def self.commit(message = "auto commit", options = {})
      options[:path] ||= Burp.content_directory
      raise "missing git repo in burp cms directory" if `cd #{options[:path]}; git st 2>&1`.match(/Not a git repository/)
      `cd #{options[:path]}; git add .; git commit -a -m "Burp: #{message}"`
    end
    
    def self.remove_all_versions_of_image(file_path)
      SIZES.each_pair do |key,value|
        target_path = "#{upload_directory_path}#{key.to_s}/#{File.basename(file_path)}"
        File.unlink(target_path)
      end
    end
    
    def self.create_smaller_images(file_path)
      
      image = Magick::ImageList.new(file_path).first
      image.auto_orient!
      
      SIZES.each_pair do |key,value|
        
        FileUtils.mkdir_p("#{upload_directory_path}#{key.to_s}")
        target_path = "#{upload_directory_path}#{key.to_s}/#{File.basename(file_path)}"
        
        if value[0] < image.columns # We only downscale
          image.resize_to_fit(value[0],value[1]).write(target_path) { self.quality = 75 }
          FileUtils.chmod(0644, target_path)
        else
          File.unlink(target_path) if File.exist?(target_path)
          File.symlink("../#{File.basename(file_path)}",target_path)
        end
      end
      image.destroy!
    end
    
    private
    
    def self.upload_directory_path
      "#{Burp.content_directory}uploads/"
    end
    
    
  end
end