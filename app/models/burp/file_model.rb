module Burp
  class FileModel
  
    attr_accessor :public_path
  
    def initialize(public_path)
      self.public_path = public_path
    end
  
    def self.all
      @file_paths = Dir.glob("#{Burp.content_directory}uploads/**/*")
      @file_paths = @file_paths.map {|path| path.gsub("#{Burp.content_directory}uploads/","/burp/files/") }
      @file_paths.map {|path| FileModel.new(path)}.sort
    end
  
    def to_param
      public_path
    end
    
    def on_disk_path
      public_path.gsub("/burp/files/","#{Burp.content_directory}uploads/")
    end
    
    def mtime
      @mtime_cache ||= File.mtime(on_disk_path)
    end
    
    def size
      @size_cache ||= File.size(on_disk_path)
    end
  
    def <=>(other)
      other.is_a?(File) ? self.mtime <=> other.mtime : 0
    end

    def eql?(other)
      self.class == other.class && self.hash == other.hash
    end

    def hash
      public_path.hash
    end
  
  end
end