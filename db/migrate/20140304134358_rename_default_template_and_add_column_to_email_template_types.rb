class RenameDefaultTemplateAndAddColumnToEmailTemplateTypes < ActiveRecord::Migration
  def change
    rename_column :email_template_types, :default_template, :default_body
    add_column :email_template_types, :default_subject, :string
  end
end
