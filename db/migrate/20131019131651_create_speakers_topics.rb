class CreateSpeakersTopics < ActiveRecord::Migration
  def up
    create_table :speakers_topics, :id => false do |t|
      t.integer :speaker_id
      t.integer :topic_id
    end
  end

  def down
    drop_table :speakers_topics
  end
end
