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

      Dir.glob(Rails.root + 'app/cms/' + "**/page.json").each do |page_data_path|
        page_data = JSON.parse(File.read(page_data_path))
        if page_data["linkLabel"]
        
          path = File.dirname(page_data_path).gsub(Rails.root.to_s+"/app/cms",'')
          section_name = File.dirname(path).gsub('/','')
        
          path = "/" if path == "/#root"
        
          groups[section_name] ||= Group.new(section_name)
          groups[section_name].children << Link.new(page_data["linkLabel"] => path)
          groups[section_name].children.sort! {|a,b| a.name <=> b.name }
        
        end
      end
    
      Group.new("root",:children => groups.values.sort {|a,b| a.name <=> b.name })
   
    end
  
  
  end
end