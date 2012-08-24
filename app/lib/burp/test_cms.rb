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
      @cached_cms_page = Burp::TestCMS.find_by_path(request_path)
      @cached_cms_page
    end
  
  
    def self.link_tree

      groups = {}
      groups[""] = Group.new("root")

      Dir.glob(Rails.root + 'app/cms/' + "**/page.json").each do |page_data_path|
        page_data = JSON.parse(File.read(page_data_path))
        unless page_data["linkLabel"].blank?
        
          path = File.dirname(page_data_path).gsub(Rails.root.to_s+"/app/cms",'')
          path = "/" if path == "/#root"
          
          group = get_group(path,groups)
          group.children << Link.new(page_data["linkLabel"] => path)
          group.children.sort! {|a,b| a.name <=> b.name }
        
        end
      end
    
      groups['']
   
    end
  
    private
    
    def self.get_group(path,groups)
      group_path = ""
      if path.match(/\/(.*?)\/([\w-]+)(\/$|$)/)
        group_path = path.match(/\/(.*?)\/([\w-]+)(\/$|$)/)[1]
      end
      
      unless(groups[group_path])
        group_name = ""
        if path.match(/\/([\w-]+(\/$|$))/)
          group_name = path.match(/\/([\w-]+(\/$|$))/)[1]
        end
      
        groups[group_path] = Group.new(group_name)
        get_group("/"+group_path,groups).children << groups[group_path]
      end
      
      groups[group_path]
    end
  
  end
end