
require 'fileutils'

module Burp
  class PageModel

    attr_accessor :path, :title, :snippets, :link_label, :misc
  
  
  
    def initialize(values = {:path => '', :snippets => {}})
      values.each_entry do |key,value|
        self.respond_to?("#{key}=".to_sym)
        self.send("#{key}=".to_sym,value)
      end
    
      @original_path = path
    end

    def self.find(path)
    
      fixed_path = path == '/' ? '/#root' : path
      on_disk_path =  Burp.current_content_directory + fixed_path
      on_disk_path = on_disk_path.gsub('//','/')
      
      if File.directory?(on_disk_path)
      
        data = {}
        Dir.glob(on_disk_path+"/*.html").each do |snippet_path|
          name = File.basename(snippet_path).split('.').first
          data[name.to_sym] = File.read(snippet_path).html_safe
        end
      
        page_data = File.exist?("#{on_disk_path}/page.json") ? JSON.parse(File.read("#{on_disk_path}/page.json")) : {}
      
        PageModel.new(:snippets => data,:title => page_data['title'],:link_label => page_data['linkLabel'],:misc => page_data['misc'],:path => path)
      else
        nil
      end
    end
  
    def self.all_paths
      ((Dir.glob("#{Burp.current_content_directory}**/*.html") + Dir.glob("#{Burp.current_content_directory}**/*.json")).map {|path| File.dirname(path.gsub(Burp.current_content_directory,"/")).gsub("/#root",'/') }).uniq
    end
  
    def self.all
      all_paths.map {|path| find(path) }
    end
  
    def save
      raise "Invalid path" unless path.match(/^[a-zA-Z0-9\-\.\/]+$/)
      raise "Path must start with a slash '/'" unless path.start_with?("/")
      raise "No path given" if path.blank?
      raise "Path already taken" if @original_path != path && File.exist?(on_disk_path)

      remove_dir
      remove_dir(@original_path) unless @original_path.blank?
      create_target_dir
      save_metadata
      save_snippets
      
      update_link_tree
      
      Burp::Util.commit("Saved #{self.path}")
    end
  
    def remove
      raise "Path must start with a slash '/'" unless path.start_with?("/")
      remove_dir
      remove_from_link_tree
      Burp::Util.commit("Removed #{self.path}")
    end
    
    def root_fixed_path(path = self.path)
      path == '/' ? '/#root' : path
    end

    private
    
    def update_link_tree(group = Site.link_tree)
      group.children.clone.each do |child|
        if child.is_a?(Link)
          if child.url == @original_path
            child.url = path
            child.name = link_label
          end
        else
          update_link_tree(child)
        end
      end
      
      group.save if group.is_a?(Menu)
    end
    
    def remove_from_link_tree(group = Site.link_tree)
      group.children.clone.each do |child|
        if child.is_a?(Link)
          group.children.delete(child) if child.url == @original_path
        else
          remove_from_link_tree(child)
        end
      end
      
      group.save if group.is_a?(Menu)
    end
  
    def save_metadata
    
      File.open("#{on_disk_path}/page.json","w:utf-8") do |file|
        file.write(JSON.pretty_generate({:title => title, :linkLabel => link_label,:misc => misc}))
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
      Dir.glob("#{on_disk_path(path)}/*").each do |path|
        File.unlink(path)
      end
  
      directory_path = on_disk_path(path)
      while(directory_path.start_with?(Burp.current_content_directory) && Dir.glob("#{directory_path}/*").length == 0)
        FileUtils.rmdir(directory_path)
        directory_path = File.dirname(directory_path)
      end
    end
  
    def on_disk_path(path = self.path)
      on_disk_path = "#{Burp.current_content_directory}#{root_fixed_path(path)}"
    end

  end
end