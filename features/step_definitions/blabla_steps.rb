Given /^I am on a cms page$/ do
  BurpFactory.create :basic_site
  visit "/"
end

When /^I change a section and reload the page$/ do
  
  while(page.evaluate_script("document.readyState") != "complete")
    sleep 0.2
  end
  
  Capybara.default_wait_time = 0.5
  begin
    page.driver.browser.action.key_down(:control).send_keys(:escape).perform
    sleep 0.2
    page.find(".dock-toolbar .icon-edit").click
  rescue => e
    page.driver.browser.action.key_down(:control).send_keys(:escape).perform
    sleep 0.2
    page.find(".dock-toolbar .icon-edit").click
  end
  Capybara.default_wait_time = 2
  
  sleep 0.2
  page.execute_script('$(".CodeMirror")[0].CodeMirror.focus()')
  page.execute_script('$(".CodeMirror")[0].CodeMirror.setValue('+'"# Hello my name is Mr Tedy Bear"'+')')
  sleep 0.2
  page.find(".dock-toolbar .icon-save").click
  sleep 0.2
  page.driver.browser.switch_to.alert.tap do |alert|
    alert.text.should include("The page was saved!")
    alert.accept
  end
  page.driver.browser.switch_to.default_content
  sleep 0.2
  page.execute_script('window.location.reload(true);')
  
  @changes = ["Hello my name is Mr Tedy Bear"]
end

Then /^I should see my changes$/ do
  @changes.each do |change|
    page.should have_content(change)
  end
end


