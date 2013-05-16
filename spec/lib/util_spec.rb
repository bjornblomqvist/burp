require 'spec_helper'

describe Burp::Util do
  
  describe ".commit" do
    
    it 'should raise an exception' do
      
      Burp.should_receive(:content_directory).and_return("/tmp/")
      lambda { Burp::Util.commit }.should raise_error
      
    end
    
  end
  
end
