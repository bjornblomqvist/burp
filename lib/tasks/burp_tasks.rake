require 'fileutils'
require 'term/ansicolor'

class BurpRakeHelper
  extend Term::ANSIColor
  
  def self.print_yellow text
    print yellow, text, reset, "\n"
  end

  def self.print_green text
    print green, text, reset, "\n"
  end
  
  
  def self.write(path)
    css_path = "#{Rails.root}#{path}"
    print "\t#{css_path}"
    if File.exist?(css_path) 
      BurpRakeHelper.print_yellow " Skipping"
    else
      FileUtils.mkdir_p(File.dirname(css_path))
      File.open(css_path,"w") do |file|
        yield file
      end
      BurpRakeHelper.print_green " OK"
    end
  end
  
end

namespace :burp do
  desc "Ads directories and confiugartion needed by burp"
  task :init do
    
    cms_root = "#{Rails.root}/app/cms"
    
    puts "\n\tBurp init\n\n"
    
    print "\t#{cms_root}"
    if File.exist?(cms_root) 
      BurpRakeHelper.print_yellow " Skipping"
    else
      FileUtils.mkdir_p(cms_root)
      BurpRakeHelper.print_green " OK"
    end
    
    print "\t#{cms_root}/.git"
    if File.exist?("#{cms_root}/.git") 
      BurpRakeHelper.print_yellow " Skipping"
    else
      `git init #{cms_root}`
      BurpRakeHelper.print_green " OK"
    end
    
    BurpRakeHelper.write('/app/cms/menus/main.yaml') do |file|
      file.write("---\n:name: root\n:children:\n")
    end
    
    BurpRakeHelper.write('/app/assets/javascripts/burp.js') do |file|
      file.write("// Includes burp related javascript.\n//\n//= require 'burp/editing'\n//= require 'burp/cms_helper'")
    end
    
    BurpRakeHelper.write("/app/assets/stylesheets/burp.css") do |file|
      file.write("/*\n * Includes burp related stylesheet.\n *\n *= require 'burp/editing'\n */")
    end
    
    BurpRakeHelper.write("/app/assets/stylesheets/customize-burp.less") do |file|
      file.write("/*\n * Add your customizations to the burp admin here.\n *\n */\n\n")
    end
    
    BurpRakeHelper.write("/app/assets/javascripts/customize-burp.js") do |file|
      file.write("/*\n * Add your customizations to the burp admin here.\n *\n */\n\n")
    end
    
    BurpRakeHelper.write("/config/initializers/burp_access.rb") do |file|
      file.write(%{
Rails.application.config.burp_username = "#{Rails.application.class.parent_name.downcase}"
Rails.application.config.burp_password = "#{('a'..'z').to_a.shuffle[0,6].join}"
      })
    end
    
    puts ""
  end
  
  desc "Creates smaller versions of the images found in the upload directory"
  task :create_smaller_images => :environment do
    Burp::FileModel.all.each do |file|
      Burp::Util.create_smaller_images(file.on_disk_path) if file.on_disk_path.match(/(jpg|jpeg|gif|png)/)
    end
    Burp::Util.commit("Burp: create_smaller_images")
  end
end

