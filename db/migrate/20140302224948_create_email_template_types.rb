class CreateEmailTemplateTypes < ActiveRecord::Migration
  def change
    create_table :email_template_types do |t|
      t.string :type_name
      t.text :description
      t.text :default_template

      t.timestamps
    end
  end
end
