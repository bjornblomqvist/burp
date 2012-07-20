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
        
        end
      end
    
      Group.new("root",:children => groups.values + [Group.new("Test1",:children => [Link.new("Its a bla bla image" => "/")]),Group.new("Test2",:children => [Link.new("Its a bla bla image" => "/blabla.jpg")])])
   
    end
  
  
  end
end