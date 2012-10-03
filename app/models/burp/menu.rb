module Burp
  class Menu < Group
   
    attr_accessor :file_name
    
    def initialize(file_name)
      raise "Name cant be blank" if file_name.blank?
      self.file_name = file_name
      load
    end
    
    def self.find(file_name)
      menu = Menu.new(file_name)
      if(menu.load)
        menu
      else
        nil
      end
    end
   
    def load
      if File.exist?(path)
        group = Group.from_yaml(File.read(path))
        self.name = group.name
        self.children = group.children
        
        true
      else
        false
      end
    end
   
    def save
     raise "Name cant be blank" if file_name.blank?

     File.open(path,'w') do |file|
       file.write(self.to_yaml)
     end

     Burp::TestCMS.commit("Saved #{self.file_name}")
    end
    
    private
    
    def path
      Burp.current_site.content_directory + file_name
    end
  end
end