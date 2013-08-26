Given /^I am editing a menu that has a group$/ do
  BurpFactory.create :basic_site
  
  menu = Burp::Menu.find("main")
  menu.children << Burp::Group.new("About bits2life")
  menu.save
  
  visit "/burp/menus/main/edit"
end

When /^I change the name of the group$/ do
  find(".group-name", :text => "About bits2life").click 
  has_css?("#my-pop-over", :visible => true) # Wait for the form to appear
  fill_in "Name", :with => "A new group name"
  click_button("Save")
end

Then /^the groups name should have changed to the new name$/ do
  page.find('.group-name').should have_content("A new group name")
end

When /^I remove the group$/ do
  find(".group-name", :text => "About bits2life").click 
  sleep 0.5
  click_on("Remove")
  page.driver.browser.switch_to.alert.tap do |alert|
    alert.text.should include("Are you sure?")
    alert.accept
  end
  page.driver.browser.switch_to.default_content
end

Then /^I should not any longer see the group in the menu$/ do
  page.all(".dnd-editable-menu").first.should_not have_content("About bits2life")
end

When /^I change the name of the group but decide not to keep the changes$/ do
  find(".group-name", :text => "About bits2life").click 
  has_css?("#my-pop-over",  :visible => true) # Wait for the form to appear
  fill_in "Name", :with => "A new group name"
  click_button("Cancel")
end

Then /^the groups name should not have changed$/ do
  page.all(".dnd-editable-menu").first.should have_content("About bits2life")
end



