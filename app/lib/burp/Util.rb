
module Burp
  module Util
  
    def self.commit(message = "auto commit")
      raise "missing git repo in burp cms directory" unless File.exist?("#{Burp.content_directory}/.git")
      `cd #{Burp.content_directory}; git add .; git commit -a -m "Burp: #{message}"`
    end
  
  end
end