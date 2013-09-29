# encoding: UTF-8

require 'spec_helper'

describe Burp::FilesController do
  
  describe "#make_url_safe" do
    it "removes some none ascii characters" do
      
      @controller = Burp::FilesController.new
      @controller.send(:make_url_safe, "ÀÁÂÃàáâãÇçĆćČčÐðÈÉÊËèéêëÌÍÎÏìíîïŁłÑñŃńÒÓÔòóôŘřŚśšÙÚÛùúûÜÝüýÅåÄÆäæÖØöø .pdf").should == "AAAAaaaaCcCcCcDdEEEEeeeeIIIIiiiillNnNnOOOoooRrSssUUUuuuUYuyAaAAaaOOoo-.pdf"
      
    end
  end
end
