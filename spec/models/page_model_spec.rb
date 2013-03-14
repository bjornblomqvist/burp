require 'spec_helper'

describe Burp::PageModel do
  
  describe "#save" do
    
    it 'should not alow a page to be saved over another one' do
      
      page = Burp::PageModel.new(:path => "/tmp/test/page1/",:snippets => {})
      page.stub(:on_disk_path).and_return("/tmp/test/page1")
      
      File.should_receive(:exist?).with("/tmp/test/page1/page.json").and_return(true)
      
      page.stub(:remove_dir)
      page.stub(:create_target_dir)
      page.stub(:save_metadata)
      page.stub(:save_snippets)
      Burp::Util.stub(:commit)
      
      page.save.should be_false
      page.errors[:path].first.should == "Path already taken, /tmp/test/page1/"
    end
    
    it 'should complain about empty path' do
      
      page = Burp::PageModel.new(:path => "",:snippets => {})
      page.save.should be_false
      page.errors[:path].first.should == "You must enter a path"
      
    end
    
    it 'should complain about invalid format' do
      
      page = Burp::PageModel.new(:path => "/hueothanh s   hueotns ueouoe/ueo",:snippets => {})
      page.save.should be_false
      page.errors[:path].first.should == "Invalid path"
      
    end
    
    it 'should complain about paths that does not start with a /' do
      
      page = Burp::PageModel.new(:path => "hipp",:snippets => {})
      page.save.should be_false
      page.errors[:path].first.should == "Must start with a slash"
      
    end
    
    it 'should raise no error when saving to the same path' do
      page = Burp::PageModel.new(:path => "/tmp/test/page1/",:snippets => {})
      page.instance_variable_set(:@original_path,"/tmp/test/page1/")
      page.stub(:on_disk_path).and_return("/tmp/test/page1")
      
      File.should_receive(:exist?).with("/tmp/test/page1/page.json").and_return(true)
      
      page.should_receive(:remove_dir)
      page.should_receive(:remove_dir).with("/tmp/test/page1/")
      page.should_receive(:create_target_dir)
      page.should_receive(:save_metadata)
      page.should_receive(:save_snippets)
    
      Burp::Util.stub(:commit)
      
      page.save.should be_true
    end
    
  end
  
  
end

