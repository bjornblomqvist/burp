
require 'fileutils'

module Burp
  class PageModel
    
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :path, :title, :snippets
  
    validates_presence_of :path, :message => "You must enter a path"
    validates :path, :format => { :with => /^\//, :message => "Must start with a slash" }
    validates :path, :format => { :with => /^[a-zA-Z0-9\-\.\/]+$/, :message => "Invalid path" }
    validate do 
      if File.exist?("#{on_disk_path}/page.json") && @original_path != path
        errors.add(:path, "Path already taken, #{path}")
        false
      else
        true
      end
    end
    
    
  
    def initialize(values = {:path => '', :snippets => {}})
      
      values.each_entry do |key,value|
        self.send("#{key}=".to_sym,value) if self.respond_to?("#{key}=".to_sym)
      end
    
      @original_path = values[:original_path]
    end

    def self.find(path)
    
      fixed_path = path == '/' ? '/#root' : path
      on_disk_path =  Burp.content_directory+"pages/" + fixed_path
      on_disk_path = on_disk_path.gsub('//','/')

      if File.directory?(on_disk_path) && File.exist?("#{on_disk_path}/page.json")
      
        data = {}
        Dir.glob(on_disk_path+"/*.html").each do |snippet_path|
          name = File.basename(snippet_path).split('.').first
          data[name.to_sym] = File.read(snippet_path).html_safe
        end
      
        page_data = File.exist?("#{on_disk_path}/page.json") ? JSON.parse(File.read("#{on_disk_path}/page.json")) : {}
      
        PageModel.new(:snippets => data,:title => page_data['title'], :path => path, :original_path => path)
      else
        nil
      end
    end
    
    def to_param
      path == "/" ? "/$root" : path
    end
    
    def id
      to_param
    end
  
    def self.all_paths
      ((Dir.glob("#{Burp.content_directory}pages/**/*.html") + Dir.glob("#{Burp.content_directory}pages/**/*.json")).map {|path| File.dirname(path.gsub(Burp.content_directory+"pages/","/")).gsub("/#root",'/') }).uniq
    end
  
    def self.all
      all_paths.map {|path| find(path) }
    end
  
    def save
      if valid?
        remove_dir
        remove_dir(@original_path) unless @original_path.blank?
        create_target_dir
        save_metadata
        save_snippets
      
        Burp::Util.commit("Saved #{self.path}")
        
        true
      else
        false
      end
    end
  
    def remove
      raise "Path must start with a slash '/'" unless path.start_with?("/")
      remove_dir
      Burp::Util.commit("Removed #{self.path}")
    end
    
    def root_fixed_path(path = self.path)
      path == '/' ? '/#root' : path
    end
    
    def persisted?
      !!@original_path
    end
    
    def self.model_name
      ActiveModel::Name.new(PageModel,nil,"Page")
    end

    private
  
    def save_metadata
    
      File.open("#{on_disk_path}/page.json","w:utf-8") do |file|
        file.write(JSON.pretty_generate({:title => title}))
      end
    
    end
  
    def save_snippets
      snippets.each_entry do |name,value|
        File.open("#{on_disk_path}/#{name}.html","w:utf-8") do |file|
          file.write(value)
        end
      end
    end
  
    def create_target_dir
      FileUtils.mkdir_p(on_disk_path)
    end
  
    def cleanup_target
      remove_dir
    end
  
    def remove_dir(path = self.path)
      Dir.glob("#{on_disk_path(path)}/*.html").each do |path|
        File.unlink(path)
      end
      
      Dir.glob("#{on_disk_path(path)}/*.json").each do |path|
        File.unlink(path)
      end

      # We only remove the dir if its actualy empyt
      if(Dir.glob("#{on_disk_path(path)}/*").length == 0)
        directory_path = on_disk_path(path)
        while(directory_path.start_with?(Burp.content_directory+"pages/") && Dir.glob("#{directory_path}/*").length == 0)
          FileUtils.rmdir(directory_path)
          directory_path = File.dirname(directory_path)
        end
      end
    end
  
    def on_disk_path(path = self.path)
      on_disk_path = "#{Burp.content_directory}pages/#{root_fixed_path(path)}"
    end

  end
end