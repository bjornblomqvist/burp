Given /^there is a page$/ do
  BurpFactory.create :basic_site
  Burp::PageModel.new(:path => "/test/a-page",:snippets => {}, :title => "A test title").save
end

When /^I go and change the title of that page$/ do
  visit "/burp/"
  click_link "Pages"
  click_link "A test title"
  fill_in "Title", :with => "The new title"
  click_button "Save"
end

Then /^that page should show the new title when viewed$/ do
  visit "/test/a-page"
  page.find("title").should have_content("The new title")
end

When /^I go and change the path of that page$/ do
  visit "/burp/"
  click_link "Pages"
  click_link "A test title"
  fill_in "Path", :with => "/a-better-path"
  click_button "Save"
end

Then /^that page should be found on the new path$/ do
  visit "/a-better-path"
  page.find("title").should have_content("A test title")
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
  click_button "Save"
end

Then /^I there should be a page$/ do
  visit "/the-new-page"
  page.find("title").should have_content("New page title")
end



