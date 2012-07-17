module Burp
  class Engine < ::Rails::Engine
    isolate_namespace Burp
    
    config.autoload_paths << File.expand_path("../../../app/lib", __FILE__)
    
  end
end
