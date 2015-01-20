class RenameAppealToSpeech < ActiveRecord::Migration
  def change
    rename_table :appeals, :speeches

    ActsAsVotable::Vote.all.each do |v|
      if v.votable_type = "Appeal"
        v.votable_type= "Speech"
        v.save
      end
    end

    Comment.all.each do |c|
      if c.commentable_type == "Appeal"
        c.commentable_type = "Speech"
        c.save
      end
    end
  end
end
