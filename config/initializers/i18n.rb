#Missing Translation handler to remove <span> tags
module I18n
  class MissingTranslation
    def html_message
      "* #{keys.join('.')}"
    end
  end
end