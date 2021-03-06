class User < ActiveRecord::Base
  has_secure_password

  validates :email, :presence => true, :uniqueness => true

  has_many :tweets, dependent: :destroy
  has_many :comments

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  def feed
    Tweet.from_users_followed_by(self)
  end

end
