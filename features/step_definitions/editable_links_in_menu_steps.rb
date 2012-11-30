When /^I add a new link$/ do
  click_link("New link")
  fill_in "Name", :with => "A new link"
  fill_in "Url", :with => "http://www.google.com/"
  click_button("Create")
end

Then /^I should see this new link$/ do
  page.should have_content("A new link")
end

Given /^I am editing a menu that has a link$/ do
  BurpFactory.create :basic_site
  
  menu = Burp::Menu.find("main")
  menu.children << Burp::Link.new("Google" => "http://google.com/")
  menu.save
  
  visit "/burp/menus/main/edit"
end

When /^I change the name of the link$/ do
  click_link("Google")
  fill_in "Name", :with => "Google now with www"
  fill_in "Url", :with => "http://www.google.com/"
  click_button("Save")
end

Then /^the links name should have changed to the new name$/ do
  page.should have_content("Google now with www")
end

