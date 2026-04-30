ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.gsub("form-control", "form-control is-invalid").gsub("form-select", "form-select is-invalid").html_safe
end 