# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

ENV["RAILS_ENV"] ||= "test"
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "/../../test/dummy"

require 'spork'

Spork.prefork do
  
  require 'capybara'
  require 'capybara/dsl'

  # Add a capybara driver with firebug
  Capybara.register_driver :with_fire_bug do |app|
    require 'selenium/webdriver'
    
    # See http://kb.mozillazine.org/About:config_entries for more cool things to configure
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = "/tmp/webdriver-downloads"
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/pdf,application/zip,image/jpeg,application/x-xpinstall" # auto saves pdfs and jpegs to the webdriver-downloads dir
    
    # (1) shows all images
    # (2) stops all images from loading
    # (3) stops all third party images
    profile['permissions.default.image'] = 1
    
    # fixes so that _blank links open in a tab
    profile['browser.link.open_newwindow'] = 3 
    profile['browser.link.open_external'] = 1
    profile['browser.link.open_external.restriction'] = 0
    profile['browser.preferences.advanced.selectedTabIndex'] = 3 
    
    profile['layout.spellcheckDefault'] = 0
    profile['toolkit.scrollbox.smoothScroll'] = false
    profile['toolkit.storage.synchronous'] = 0
    
    profile['extensions.firebug.script.enableSites'] = true
    profile['extensions.firebug.console.enableSites'] = true
    profile['extensions.firebug.net.enableSites'] = true
    
    profile['extensions.firebug.defaultPanelName'] = 'console'
    profile['extensions.firebug.previousPlacement'] = 3
    
    profile.add_extension "#{File.dirname(__FILE__)}/firebug-1.10.4-fx.xpi"
    
    Capybara::Selenium::Driver.new(app, :profile => profile)
  end
  
  
  # Fix so that we can manualy start the server, and so that we can controll when the state is reset
  # class Capybara::Selenium::Driver < Capybara::Driver::Base
  #   def start_server(app)
  #     @rack_server.app = app
  #     @rack_server.boot
  #   end
  #   
  #   alias_method :real_reset!, :reset!
  #   def reset!
  #   end
  # end
  # 
  # class Capybara::Server
  #   def app=(app)
  #     @app = app
  #   end
  # end
  # 
  # class Capybara::Session
  #   def app=(app)
  #     @app = app
  #   end
  # end
  # 
  # module Capybara
  #   def self.current_session=(session)
  #     session_pool["#{current_driver}:#{session_name}:#{app.object_id}"] = session
  #   end
  # end

  Capybara.server_port = 7012
  Capybara.default_selector = :css
  Capybara.default_driver = :with_fire_bug

  # Capybara.run_server = false
  # Capybara.current_session.visit('/')
  # Capybara.run_server = true
  
end

Spork.each_run do
  # 
  # old_session = Capybara.current_session
  
  require 'cucumber/rails'
  
  # old_session.app = Capybara.app
  # Capybara.current_session = old_session
  
  Burp.global_content_directory = "/tmp/burp-test-cms/"
  require_relative "./burp_factory"
  
  # Capybara.current_session.driver.start_server(old_session.app)
  
  # By default, any exception happening in your Rails application will bubble up
  # to Cucumber so that your scenario will fail. This is a different from how 
  # your application behaves in the production environment, where an error page will 
  # be rendered instead.
  #
  # Sometimes we want to override this default behaviour and allow Rails to rescue
  # exceptions and display an error page (just like when the app is running in production).
  # Typical scenarios where you want to do this is when you test your error pages.
  # There are two ways to allow Rails to rescue exceptions:
  #
  # 1) Tag your scenario (or feature) with @allow-rescue
  #
  # 2) Set the value below to true. Beware that doing this globally is not
  # recommended as it will mask a lot of errors for you!
  #
  ActionController::Base.allow_rescue = false

  # Remove/comment out the lines below if your app doesn't have a database.
  # For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
  begin
    DatabaseCleaner.strategy = :transaction
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end

  # You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
  # See the DatabaseCleaner documentation for details. Example:
  #
  #   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
  #     # { :except => [:widgets] } may not do what you expect here
  #     # as tCucumber::Rails::Database.javascript_strategy overrides
  #     # this setting.
  #     DatabaseCleaner.strategy = :truncation
  #   end
  #
  #   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
  #     DatabaseCleaner.strategy = :transaction
  #   end
  #

  Before do
    # Capybara.current_session.driver.real_reset!
    BurpFactory.clear
  end

  # Possible values are :truncation and :transaction
  # The :transaction strategy is faster, but might give you threading problems.
  # See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
  Cucumber::Rails::Database.javascript_strategy = :truncation
end

