When /^I add a new link$/ do
  click_link("New link")
  fill_in "Name", :with => "A new link"
  fill_in "Url", :with => "http://www.google.com/"
  click_button("Create")
end

Then /^I should see this new link$/ do
  page.find(".container .group").should have_content("A new link")
end
