require 'bootstrap_forms'
require 'bootstrap_forms/helpers'

ActionView::Base.send :include, BootstrapForms::Helpers::FormHelper
ActionView::Base.send :include, BootstrapForms::Helpers::FormTagHelper
ActionView::Base.send :include, BootstrapForms::Helpers::NestedFormHelper

# Do not wrap errors in the extra div
::ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  html_tag
end