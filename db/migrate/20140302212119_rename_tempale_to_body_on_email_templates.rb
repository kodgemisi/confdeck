class RenameTempaleToBodyOnEmailTemplates < ActiveRecord::Migration
  def change
    rename_column :email_templates, :template, :body
  end
end
