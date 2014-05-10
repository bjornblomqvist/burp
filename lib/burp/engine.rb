module Burp
  class Engine < ::Rails::Engine
    
    # These require are need so that jquery and jquery-ui are included into the asset pipeline.
    require 'jquery-rails'
    require 'jquery-ui-rails'
    
    isolate_namespace Burp
    
    config.autoload_paths << File.expand_path("../../../app/lib", __FILE__)
    
    # Enabling assets precompiling under rails 3.1
    if Rails.version >= '3.1'
      initializer :assets do |config|
        Rails.application.config.assets.precompile += %w( burp/editing.css burp/editing.js burp/snippets.js)
      end
    end
    
  end
end
