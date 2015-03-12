# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

class Comment < ActiveRecord::Base
  after_create :send_email

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true
  delegate :topic, :to => :commentable, :allow_nil => true

  default_scope { order("created_at DESC") }
  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  def email?
    sent_by_email
  end


  def send_email
    SpeechMailer.new_comment_email(self.commentable, self).deliver!
  end
end
