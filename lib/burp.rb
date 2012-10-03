require "burp/engine"
require "mayi"

##
# All paths to directories are expected to end with a slash.
#
# Like this  +/home/darwin/+
#
module Burp
  
  @@content_directory = nil
  @@upload_directory = nil
  
  ##
  # Returns the upload directory to use.
  #
  # Can be overiden on a thread basis by setting Thread.current[ :burp_upload_directory ]
  #
  def self.upload_directory
    Thread.current[:burp_upload_directory] || @@upload_directory || Burp.content_directory+"uploads/".to_s
  end
  
  def self.upload_directory=(path)
    @@upload_directory = path
  end
  
  ##
  # Returns the content directory to use.
  #
  # Can be overiden on a thread basis by setting  Thread.current[ :burp_content_directory ]
  #
  def self.content_directory
    Thread.current[:burp_content_directory] || @@content_directory || Rails.root.join('app/cms/default/').to_s
  end
  
  def self.content_directory=(path)
     @@content_directory = path
  end
  
  def self.access
    @@access ||= MayI::Access.new("Burp::Access")
  end
  
end
