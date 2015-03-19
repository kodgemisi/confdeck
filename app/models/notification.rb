class Notification < ActiveRecord::Base
  enum status: [:unread, :read]
  belongs_to :subject, polymorphic: true
  belongs_to :user
end
