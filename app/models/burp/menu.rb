module Burp
  class Menu < Group
   
    def initialize(name,options = {})
      raise "Name cant be blank" if name.blank?
      self.name = name
      super(name,options)
    end
    
    def self.all
      Dir.glob(Burp.content_directory + "menus/*.yaml").map do |menu_path|
        Menu.find(menu_path.match(/\/(\w*?)\.yaml$/)[1])
      end
    end
    
    def self.find(name)
      menu = Menu.new(name)
      if(menu.load)
        menu
      else
        nil
      end
    end
    
    def to_param
      name
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
     raise "Name cant be blank" if name.blank?

     File.open(path,'w') do |file|
       file.write(self.to_yaml)
     end

     Burp::Util.commit("Saved #{self.name}")
    end
    
    private
    
    def path
      Burp.content_directory + "menus/" +  name + ".yaml"
    end
  end
end