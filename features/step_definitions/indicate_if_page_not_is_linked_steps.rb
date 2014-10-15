Given(/^I have two pages$/) do
  BurpFactory.create
  Burp::PageModel.new(:path => "/page1", :snippets => {:main => ""}, :title => "Page one").save
  Burp::PageModel.new(:path => "/page2", :snippets => {:main => ""}, :title => "Page two").save
end

When(/^I go to the page listing$/) do
  visit "/burp/pages"
end

Then(/^I should that none of the pages are linked$/) do
  page.should have_css(".not-linked", :count => 2)
end

Given(/^one of them is linked in a menu$/) do
  menu = Burp::Menu.find("main")
  menu.children << Burp::Link.new(:url => "/page1", :name => "Page one")
  menu.save
end

Then(/^I should see that only one of them is not linked$/) do
  page.should have_css(".not-linked", :count => 1)
end

