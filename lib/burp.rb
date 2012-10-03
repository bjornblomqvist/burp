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
  # Returns the content directory to use.
  #
  def self.content_directory
    @@content_directory || Rails.root.join('app/cms/').to_s
  end
  
  def self.content_directory=(path)
     @@content_directory = path
  end
  
  def self.default_site
    @@default_site_cache ||= Site.new
  end
  
  def self.current_site
    Thread.current[:burp_current_site] || default_site
  end
  
  def self.current_site=(site)
    Thread.current[:burp_current_site] = site
  end
  
  def self.access
    @@access ||= MayI::Access.new("Burp::Access")
  end
  
end
