Given /^I am on the edit menu page$/ do
  BurpFactory.create :basic_site
  visit "/burp/menus/main/edit"
end

When /^I add a new group$/ do
  click_link("Add group")
  fill_in "Name", :with => "A new group"
  click_button("Create")
end

Then /^I should see this new group$/ do
  page.should have_content("A new group")
end
