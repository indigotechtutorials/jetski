module ReactiveForm
  def reactive_text_area(path, **opts)
    css_classes = opts[:class]
    # Text area that auto saves to url.
    "<textarea reactive-form-path='#{path}' class='#{css_classes}'></textarea>"
  end
end