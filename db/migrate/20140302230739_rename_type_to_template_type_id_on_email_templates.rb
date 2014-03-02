class RenameTypeToTemplateTypeIdOnEmailTemplates < ActiveRecord::Migration
  def change
    remove_column :email_templates, :type
    add_column :email_templates, :email_template_type_id, :integer
  end
end
