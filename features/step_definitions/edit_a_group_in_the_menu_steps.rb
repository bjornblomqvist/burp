Given /^I am editing a menu that has a group$/ do
  BurpFactory.create :basic_site
  
  menu = Burp::Menu.find("main")
  menu.children << Burp::Group.new("About bits2life")
  menu.save
  
  visit "/burp/menus/main/edit"
end

When /^I change the name of the group$/ do
  click_link "About bits2life"
  fill_in "Name", :with => "A new group name"
  click_button("Save")
end

Then /^the groups name should have changed to the new name$/ do
  page.find(".container .group").should have_content("A new group name")
end



