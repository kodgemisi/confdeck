class AddGithubToSpeakers < ActiveRecord::Migration
  def change
    add_column :speakers, :github, :string
  end
end
