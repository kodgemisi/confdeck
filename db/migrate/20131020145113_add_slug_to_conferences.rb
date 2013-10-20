class AddSlugToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :slug, :string
    add_index :conferences, :slug, unique: true
  end
end
