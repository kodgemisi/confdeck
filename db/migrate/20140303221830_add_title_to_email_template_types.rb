class AddTitleToEmailTemplateTypes < ActiveRecord::Migration
  def change
    add_column :email_template_types, :title, :string
  end
end
