class EmailTemplate < ActiveRecord::Base
  attr_accessible :conference_id, :subject, :template, :type
end
