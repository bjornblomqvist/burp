module Burp
  class Engine < ::Rails::Engine
    isolate_namespace Burp
    
    config.autoload_paths << File.expand_path("../../../app/lib", __FILE__)
    
    # Enabling assets precompiling under rails 3.1
    if Rails.version >= '3.1'
      initializer :assets do |config|
        Rails.application.config.assets.precompile += %w( burp/editing.less burp/editing.js )
      end
    end
    
  end
end
