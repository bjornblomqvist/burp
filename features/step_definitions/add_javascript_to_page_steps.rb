When /^I add a alert box to a section$/ do
  
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
  page.execute_script('$(".CodeMirror")[0].CodeMirror.setValue('+'"<script type=\"text/javascript\" >alert(\"This is a alert box\");</script>"'+')')
  
end

Then /^I should see message about javascript$/ do
  page.find('#gritter-notice-wrapper').should have_content("The javascript will not be previewed but it will be saved.")
end

