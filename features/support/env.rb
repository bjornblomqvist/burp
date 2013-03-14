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

  # Start selenium
  require 'selenium/webdriver'

  # See http://kb.mozillazine.org/About:config_entries for more cool things to configure
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = "/tmp/cqr-tests/webdriver-downloads"
  profile['browser.download.folderList'] = 2
  profile['browser.helperApps.neverAsk.saveToDisk'] = "application/pdf,application/zip,image/jpeg,application/x-xpinstall,image/svg+xml" # auto saves pdfs and jpegs to the webdriver-downloads dir

  profile["browser.helperApps.alwaysAsk.force"] = false
  profile["browser.download.manager.showWhenStarting"] = false

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

  @driver = Capybara::Selenium::Driver.new(nil, :profile => profile)
  @driver.browser
   
  Capybara.server_port = 7003
  Capybara.default_selector = :css
  Capybara.app_host = "http://localhost:7003"
  Capybara.default_driver = :selenium
  
end

Spork.each_run do

  require 'cucumber/rails'
  
  # This is the magick that gives me good errors
  ActionController::Base.allow_rescue = true
    
  @driver.instance_variable_set(:@app,Capybara.current_session.app)
  Capybara.current_session.instance_variable_set(:@driver, @driver)
  
  begin
    @driver.reset!
    DatabaseCleaner.strategy = :truncation
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end

  Before do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
    Dir.glob("/tmp/cqr-tests/webdriver-downloads/*") do |path|
      File.unlink(path) 
    end
  end

end


