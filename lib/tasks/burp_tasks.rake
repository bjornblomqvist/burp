require 'fileutils'
require 'term/ansicolor'

class MyPrinter
  include Term::ANSIColor
  def self.print_yellow text
    print yellow, text, reset, "\n"
  end

  def self.print_green text
    print green, text, reset, "\n"
  end
end

namespace :burp do
  desc "Ads directories and confiugartion needed by burp"
  task :init do
    
    cms_root = "#{Rails.root}/app/cms"
    
    puts "\n\tBurp init\n\n"
    
    print "\t#{cms_root}"
    if File.exist?(cms_root) 
      MyPrinter.print_yellow " Skipping"
    else
      FileUtils.mkdir_p(cms_root)
      MyPrinter.print_green " OK"
    end
    
    print "\t#{cms_root}/.git"
    if File.exist?("#{cms_root}/.git") 
      MyPrinter.print_yellow " Skipping"
    else
      `git init #{cms_root}`
      MyPrinter.print_green " OK"
    end
    
    menu_path = "#{Rails.root}/app/cms/menus/main.yaml"
    print "\t#{menu_path}"
    if File.exist?(menu_path) 
      MyPrinter.print_yellow " Skipping"
    else
      FileUtils.mkdir_p(File.dirname(menu_path))
      File.open(menu_path,"w") do |file|
        file.write("---\n:name: root\n:children:\n")
      end
      MyPrinter.print_green " OK"
    end
    
    js_path = "#{Rails.root}/app/assets/javascripts/burp.js"
    print "\t#{js_path}"
    if File.exist?(js_path) 
      MyPrinter.print_yellow " Skipping"
    else
      File.open(js_path,"w") do |file|
        file.write("// Includes burp related javascript.\n//\n//= require 'burp/editing'\n//= require 'burp/cms_helper'")
      end
      MyPrinter.print_green " OK"
    end
    
    css_path = "#{Rails.root}/app/assets/stylesheets/burp.css"
    print "\t#{css_path}"
    if File.exist?(css_path) 
      MyPrinter.print_yellow " Skipping"
    else
      File.open(css_path,"w") do |file|
        file.write("/*\n * Includes burp related stylesheet.\n *\n *= require 'burp/editing'\n */")
      end
      MyPrinter.print_green " OK"
    end
    
    access_path = "#{Rails.root}/config/initializers/burp_access.rb"
    print "\t#{access_path}"
    if File.exist?(access_path) 
      MyPrinter.print_yellow " Skipping"
    else
      File.open(access_path,"w") do |file|
        file.write(%{
Rails.application.config.burp_username = "#{Rails.application.class.parent_name.downcase}"
Rails.application.config.burp_password = "#{('a'..'z').to_a.shuffle[0,6].join}"
        })
      end
      MyPrinter.print_green " OK"
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

