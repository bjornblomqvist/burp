
module Burp
  module Util
  
    def self.commit(message = "auto commit")
      `cd #{Burp.current_content_directory}; git add .; git commit -a -m "Burp: #{message}"`
    end
  
  end
end