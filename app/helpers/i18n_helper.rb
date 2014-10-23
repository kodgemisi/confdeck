module I18nHelper
  def translate(key, options={})
    super(key, options.merge(raise: true))
  rescue I18n::MissingTranslationData
    key.split(".").last.humanize + "*"
  end
  alias :t :translate
end