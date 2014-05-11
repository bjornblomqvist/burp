When(/^I add a meta description for this page$/) do
  visit "/burp/"
  click_link "Pages"
  find("tr", :text => "A test title").click_link "Edit"
  fill_in "Meta description", :with => "This is a test page"
  click_button "Save"
end

Then(/^I should see the description in the header of the page$/) do
  visit "/test/a-page"
  page.find('meta[name="description"]', :visible => false)['content'].should == "This is a test page"
end