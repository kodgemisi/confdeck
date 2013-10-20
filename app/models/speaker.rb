class Speaker < ActiveRecord::Base
  attr_accessible :email, :facebook, :name, :phone, :twitter, :bio, :github

  has_and_belongs_to_many :topics

  def avatar_url(size=150)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end
end
