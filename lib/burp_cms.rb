require "burp/engine"
require "mayi"
require "burp/version"

##
# All paths to directories are expected to end with a slash.
#
# Like this  +/home/darwin/+
#
module Burp
  
  @@content_directory = nil
  @@access_builder = nil
  
  
  def self.find_page(path)
    page_model = Burp::PageModel.find(path)
    if page_model 
      Page.new(:snippets => page_model.snippets, :title => page_model.title)
    end
  end
  
  
  
  def self.new_access_instance(request, controller)
    if @@access_builder
      @@access_builder.call(request, controller)
    else
      Burp::Access.new
    end
  end
  
  def self.set_access_builder &block
    @@access_builder = block
  end
  
  

  ##
  # Returns the content directory to use.
  #
  def self.content_directory
    Thread.current[:thread_local_content_directory] || @@content_directory || Rails.root.join('app/cms/').to_s
  end
    
  ##
  # Runs the block with the content directory temporarly set to the supplied path
  #
  def self.with_content_directory(path,&block)
    self.thread_local_content_directory = path
    block.call
  ensure  
    self.thread_local_content_directory = nil
  end
  
  ##
  # Sets the content directory
  #
  def self.global_content_directory=(path)
    raise "#{path} does not end with '/'" unless path.end_with?('/')
    @@content_directory = path
  end
  
  ##
  # Sets the content directory for the current thread
  #
  def self.thread_local_content_directory=(path)
    raise "#{path} does not end with '/'" unless path.end_with?('/')
    Thread.current[:thread_local_content_directory] = path
  end
  
  
end
