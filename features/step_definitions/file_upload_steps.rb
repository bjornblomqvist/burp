
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
