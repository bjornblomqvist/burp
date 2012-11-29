require "fileutils"

class BurpFactory
  
  def self.create type
    
    raise "Cant create dummy site as #{Burp.content_directory} is not empty!" if File.exist?(Burp.content_directory)
    
    path_to_burp_files_directory = Burp.content_directory+"/"
    FileUtils.mkdir_p(path_to_burp_files_directory)
    
    `cd #{path_to_burp_files_directory}; git init` if File.exist?(path_to_burp_files_directory) && File.directory?(path_to_burp_files_directory)
    
    if type == :basic_site
      page = Burp::PageModel.new(:path => "/", :snippets => {:main => ""})
      page.save
      
      default_menu = Burp::Menu.new("default.yaml")
      default_menu.children << Burp::Link.new(:url => "/", :name => "Start page")
      default_menu.save
    end
  end
  
  def self.clear
    path_to_burp_files_directory = Burp.content_directory
    `rm -rf #{path_to_burp_files_directory}` if File.exist?(path_to_burp_files_directory) && File.directory?(path_to_burp_files_directory)
  end
  
end