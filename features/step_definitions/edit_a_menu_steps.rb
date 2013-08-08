Given /^I am on the first page of the admin$/ do
  BurpFactory.create :basic_site
  
  visit "/burp/"
end

When /^I go and add a link to the first menu$/ do
  click_link "Menu"
  click_link "New link"
  fill_in "Name", :with => "A new link"
  fill_in "Url", :with => "http://video.google.com/"
  click_button "Create"
end

Then /^I should see the new link in the menu$/ do
  find('a', :text => "A new link")
end



