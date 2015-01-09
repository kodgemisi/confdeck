
module Conferences
  class CreateConferenceService < BaseService
    def call(params, current_user)
      @conference = Conference.new(params)

      Conference.transaction do
        @result = @conference.save
        if @result
          @conference.conference_admins << current_user
          current_user.conference_wizard.destroy if current_user.conference_wizard
          #TODO send creation mail?
        end
      end

      @conference
    end
  end
end