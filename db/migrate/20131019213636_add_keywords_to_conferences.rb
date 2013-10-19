class AddKeywordsToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :keywords, :string
  end
end
