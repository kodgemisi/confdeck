class EmailTemplate < ActiveRecord::Base
  attr_accessible :conference_id, :subject, :template, :type

  belongs_to :conference

  self.inheritance_column = :class_type #because type field is reserved for rails
end
