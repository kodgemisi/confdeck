class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.text :template
      t.string :type
      t.string :subject
      t.integer :conference_id

      t.timestamps
    end
  end
end
