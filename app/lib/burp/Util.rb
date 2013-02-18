
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
      sizes.each_pair do |key,value|
        FileUtils.mkdir_p("#{upload_directory_path}#{key.to_s}")
        if value[0] < image.columns # We only downscale
          image.resize_to_fit(value[0],value[1]).write("#{upload_directory_path}#{key.to_s}/#{File.basename(file_path)}")
        else
          image.write("#{upload_directory_path}#{key.to_s}/#{File.basename(file_path)}")
        end
      end
      image.destroy!
    end
    
  end
end