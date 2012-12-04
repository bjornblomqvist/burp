
Given /^there are no files$/ do
  BurpFactory.create :basic_site
end

When /^I go and upload a file$/ do
  visit "/burp/files/"
  find(:css,"input[type=file]",:visible => false).set(File.expand_path("./features/test_files/dummy_text.txt"))
end

Then /^there should be one file that i can link to$/ do
  page.find("a:contains(\"dummy_text.txt\")").should have_content("dummy_text.txt")
end

Given /^there is a file$/ do
  BurpFactory.create :basic_site
  FileUtils.mkdir_p("#{Burp.content_directory}uploads/")
  `cp #{File.expand_path("./features/test_files/dummy_text.txt")} #{Burp.content_directory}uploads/`
end

When /^I go and remove it$/ do
  visit "/burp/files/"
  click_link "Remove"
  page.driver.browser.switch_to.alert.tap do |alert|
    alert.text.should include("Are you sure?")
    alert.accept
  end
  page.driver.browser.switch_to.default_content
end

Then /^there should be no files$/ do
  visit "/burp/files/"
  page.should_not have_content("dummy_text.txt")
end

