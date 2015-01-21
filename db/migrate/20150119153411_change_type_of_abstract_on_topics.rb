class ChangeTypeOfAbstractOnTopics < ActiveRecord::Migration
  def up
    change_column :topics, :abstract, :text
  end

  def down
    change_column :topics, :abstract, :string
  end
end
