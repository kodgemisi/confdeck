class EmailTemplateType < ActiveRecord::Base
  attr_accessible :default_body, :default_subject, :description, :type_name, :title

  has_many :email_templates
end
