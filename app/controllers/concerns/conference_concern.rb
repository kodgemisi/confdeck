require 'active_support/concern'

module ConferenceConcern
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def parse_dates
      @conference.to_date = @conference.days.last.date.strftime(I18n.t("date.formats.default"))
      @conference.from_date = @conference.days.first.date.strftime(I18n.t("date.formats.default"))
      @one_day = (@conference.days.first == @conference.days.last)
    end
  end

end