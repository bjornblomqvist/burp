Given /^there is a page$/ do
  BurpFactory.create :basic_site
  Burp::PageModel.new(:path => "/test/a-page",:snippets => {}, :title => "A test title").save
end

When /^I go and change the title of that page$/ do
  visit "/burp/"
  click_link "Pages"
  find("tr", :text => "A test title").click_link "Edit"
  fill_in "Title", :with => "The new title"
  click_button "Save"
end

Then /^that page should show the new title when viewed$/ do
  visit "/test/a-page"
  page.has_title?("The new title")
end

When /^I go and change the path of that page$/ do
  visit "/burp/"
  click_link "Pages"
  find("tr", :text => "A test title").click_link "Edit"
  has_css?("#my-pop-over", :visible => true) # Wait for the form to appear
  fill_in "Path", :with => "/a-better-path"
  click_button "Save"
end

Then /^that page should be found on the new path$/ do
  visit "/a-better-path"
  page.has_title?("A test title")
end

Given /^there are no pages$/ do
  BurpFactory.create :basic_site
  Burp::PageModel.all.each do |page|
    page.remove
  end
end

When /^I go and add a page$/ do
  visit "/burp/"
  click_link "Pages"
  click_link "New page"
  fill_in "Title", :with => "New page title"
  fill_in "Path", :with => "/the-new-page"
  click_button "Create"
end

Then /^I there should be a page$/ do
  visit "/the-new-page"
  page.has_title?("New page title")
end

When /^I remove the page$/ do
  visit "/burp/"
  click_link "Pages"
  find("tr", :text => "Start page").click_link "Edit"
  has_css?("#my-pop-over", :visible => true) # Wait for the form to appear
  click_on "Remove"
  page.driver.browser.switch_to.alert.tap do |alert|
    alert.text.should include("Are you sure?")
    alert.accept
  end
  page.driver.browser.switch_to.default_content
end

Then /^there should be no pages$/ do
  page.should_not have_content("Start page")
end

When /^I go and add a page without a page path$/ do
  visit "/burp/"
  click_link "Pages"
  click_link "New page"
  fill_in "Title", :with => "New page title"
  
  # We turn off HTML5 validation so that we can test the error handeling
  page.execute_script('$("form").attr("novalidate","novalidate");')
  
  click_button "Create"
end

Then /^I should be told that i must enter a page path$/ do
  page.should have_content('You must enter a path')
end







