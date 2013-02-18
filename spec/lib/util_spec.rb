require 'spec_helper'

describe Burp::Util do
  
  describe ".commit" do
    
    it 'should raise an exception' do
      
      File.should_receive(:exist?).with("#{Burp.content_directory}/.git").and_return(false)
      lambda { Burp::Util.commit }.should raise_error
      
    end
    
  end
  
end
