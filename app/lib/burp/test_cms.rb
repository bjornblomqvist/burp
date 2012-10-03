module Burp
  class TestCMS
  
    def self.find_by_path(path)
    
      page_model = PageModel.find(path)
      
      if page_model
        Page.new(page_model.snippets,page_model.title,TestCMS.link_tree)
      else
        Page.new(TestCMS.link_tree)
      end
    end
    
    def self.cms_page(request_path)
      find_by_path(request_path)
    end
  
    def self.link_tree
      Menu.find("menu.yaml") || default_link_tree
    end
  
    def self.default_link_tree

      groups = {}
      groups[""] = Group.new("root")

      Dir.glob(Burp.content_directory + "**/page.json").each do |page_data_path|
        page_data = JSON.parse(File.read(page_data_path))
        unless page_data["linkLabel"].blank?
        
          path = File.dirname(page_data_path).gsub(Burp.content_directory,'/')
          path = "/" if path == "/#root"
          
          group = get_group(path,groups)
          group.children << Link.new(page_data["linkLabel"] => path)
          group.children.sort! {|a,b| a.name <=> b.name }
        
        end
      end
    
      groups['']
   
    end
    
    def self.commit(message = "auto commit")
      `cd #{Burp.content_directory}; git add .; git commit -a -m "Burp: #{message}"`
    end
  
    private
    
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