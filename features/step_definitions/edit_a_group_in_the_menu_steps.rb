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

When /^I remove the group$/ do
  click_link("About bits2life")
  click_button("Remove")
  page.driver.browser.switch_to.alert.tap do |alert|
    alert.text.should include("Are you sure?")
    alert.accept
  end
  page.driver.browser.switch_to.default_content
end

Then /^I should not any longer see the group in the menu$/ do
  page.find(".dnd-editable-menu").should_not have_content("About bits2life")
end

When /^I change the name of the group but deside not to keep the changes$/ do
  click_link "About bits2life"
  fill_in "Name", :with => "A new group name"
  click_button("Cancel")
end

Then /^the groups name should not have changed$/ do
  page.find(".dnd-editable-menu").should have_content("About bits2life")
end



