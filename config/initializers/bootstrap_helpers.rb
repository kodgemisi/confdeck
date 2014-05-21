module RailsBootstrapHelpers::Helpers::BaseHelper

  def icon (icon, options = {})
    options = options.dup

    icon = ERB::Util.html_escape(icon.to_s)
    append_class!(options, "ico-" + icon)

    if options.delete(:invert)
      append_class!(options, "icn-white")
    end

    cls = options[:class]

    "<i class=\"#{cls}\"></i>".html_safe
  end
end