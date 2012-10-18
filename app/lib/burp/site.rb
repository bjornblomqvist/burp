module Burp
  class Site
    
    attr_accessor :domain_name
    
    def self.find(domain_name) 
      
      if File.exist?("#{Burp.content_directory}#{domain_name}/")
        Site.new(domain_name,"#{Burp.content_directory}#{domain_name}/")
      else
        Dir["#{Burp.content_directory}*"].each do |file|
          
          if file.match(/\*/)
            base_name = File.basename(file)
            domain_regexp = Regexp.new("^"+(base_name.gsub('.','\.').gsub('*','.*'))+"$")
            return Site.new(domain_name,file+"/") if domain_regexp.match(domain_name)
          end
        end
        
        nil
      end
      
    end
    
    def site_content_directory
      @content_directory
    end
    
    def site_upload_directory
      site_content_directory+"uploads/".to_s
    end
    
    def find_page(path)
      
      Burp.with_content_directory(site_content_directory) do
        page_model = PageModel.find(path)

        to_return = if page_model
          Page.new(page_model.snippets,page_model.title,link_tree)
        else
          Page.new(link_tree)
        end
      end
      
    end
    
    def link_tree
      Burp.with_content_directory(site_content_directory) do
        Site.link_tree
      end
    end
    
    def self.link_tree
      Menu.find("menu.yaml") || default_link_tree
    end
  
    def default_link_tree 
      Burp.with_content_directory(site_content_directory) do
        Site.default_link_tree
      end
    end
  
    def self.default_link_tree       
      groups = {}
      groups[""] = Group.new("root")

      Dir.glob(Burp.current_content_directory + "**/page.json").each do |page_data_path|
        page_data = JSON.parse(File.read(page_data_path))
        unless page_data["linkLabel"].blank?

          path = File.dirname(page_data_path).gsub(Burp.current_content_directory,'/')
          path = "/" if path == "/#root"

          group = get_group(path,groups)
          group.children << Link.new(page_data["linkLabel"] => path)
          group.children.sort! {|a,b| a.name <=> b.name }

        end
      end

      groups['']
    end
    
    def self.default
      Site.new('default',"#{Burp.content_directory}default/")
    end
    
    private
    
    def initialize(domain_name,content_directory)
      raise "Directories must end with '/'" unless content_directory.end_with?('/')
      
      @domain_name = domain_name
      @content_directory = content_directory
    end
    
    def self.get_group(path,groups)
      group_path = ""
      if path.match(/\/(.*?)\/([\w-]+)(\/$|$)/)
        group_path = path.match(/\/(.*?)\/([\w-]+)(\/$|$)/)[1]
      end
      
      unless(groups[group_path])
        group_name = ""
        if ("/"+group_path).match(/\/([\w-]+(\/$|$))/)
          group_name = ("/"+group_path).match(/\/([\w-]+(\/$|$))/)[1]
        end
      
        groups[group_path] = Group.new(group_name)
        get_group("/"+group_path,groups).children << groups[group_path]
      end
      
      groups[group_path]
    end
    
  end
end