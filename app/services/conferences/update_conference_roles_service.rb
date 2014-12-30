module Conferences
  class UpdateConferenceRolesService < BaseService
    def call(conference, conference_admins = [], conference_users = [])
      conference_users ||= []
      conference_admins ||= []
      conference.conference_admins.delete_all
      conference_admins.each do |id|
        conference.conference_admins << User.find(id)
      end

      conference.conference_users.delete_all
      conference_users.each do |id|
        conference.conference_users << User.find(id)
      end
    end
  end
end