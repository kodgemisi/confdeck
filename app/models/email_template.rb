class EmailTemplate < ActiveRecord::Base
  belongs_to :conference
  belongs_to :email_template_type

  self.inheritance_column = :class_type #because type field is reserved for rails
end
