require "burp/engine"

module Burp
  
  class << self
    def upload_directory
      Rails.root.join('app/cms/uploads/').to_s
    end
  end
  
end
