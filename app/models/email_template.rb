class EmailTemplate < ActiveRecord::Base
  attr_accessible :conference_id, :subject, :body, :type

  belongs_to :conference
  belongs_to :email_template_type

  self.inheritance_column = :class_type #because type field is reserved for rails
end
