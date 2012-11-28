require "burp/engine"
require "mayi"

##
# All paths to directories are expected to end with a slash.
#
# Like this  +/home/darwin/+
#
module Burp
  
  @@content_directory = nil

  ##
  # Returns the content directory to use.
  #
  def self.content_directory
    @@content_directory || Rails.root.join('app/cms/').to_s
  end
  
  def self.content_directory=(new_content_directory)
    raise "Directories must end with '/'" unless new_content_directory.end_with?('/')
    @@content_directory = new_content_directory
  end
  
  def self.current_content_directory
    Thread.current[:burp_current_content_directory] || @@content_directory
  end
  
  def self.access
    @@access ||= MayI::Access.new("Burp::Access")
  end
  
  def self.with_content_directory(content_directory,&block)
    
    raise "Directories must end with '/'" unless content_directory.end_with?('/')
    
    Thread.current[:burp_current_content_directory] = content_directory
    
    block.call
  
  ensure  
    Thread.current[:burp_current_content_directory] = nil
  end
  
end
