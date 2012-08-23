require "burp/engine"
require "mayi"

module Burp
  
  def self.upload_directory
    Rails.root.join('app/cms/uploads/').to_s
  end
  
  def self.access
    @@access ||= MayI::Access.new("Burp::Access")
  end
  
end
