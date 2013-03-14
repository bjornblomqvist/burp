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
  has_css?("#my-pop-over", :visible => true) # Wait for the form to appear
  fill_in "Name", :with => "Google now with www"
  fill_in "Url", :with => "http://www.google.com/"
  click_button("Save")
end

Then /^the links name should have changed to the new name$/ do
  page.find(".dnd-editable-menu").should have_content("Google now with www")
end

When /^I remove the link$/ do
  click_link("Google")
  has_css?("#my-pop-over",  :visible => true) # Wait for the form to appear
  click_button("Remove")
  page.driver.browser.switch_to.alert.tap do |alert|
    alert.text.should include("Are you sure?")
    alert.accept
  end
  page.driver.browser.switch_to.default_content
end

Then /^I should not any longer see the link in the menu$/ do
  page.find(".dnd-editable-menu").should_not have_content("Google")
end

When /^I enter a new name for the link but i dont save the changes$/ do
  click_link("Google")
  has_css?("#my-pop-over",  :visible => true) # Wait for the form to appear
  fill_in "Name", :with => "Google now with www"
  fill_in "Url", :with => "http://www.google.com/"
  click_button("Cancel")
end

Then /^the links name should not have changed$/ do
  page.find(".dnd-editable-menu").should have_content("Google")
end





