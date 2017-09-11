class User < ApplicationRecord
	has_many :microposts, dependent: :destroy
	has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
	has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password
	validates :password, presence: true, length: { minimum: 6 }

	def feed_search(search)
    	#Micropost.where("user_id = ?", id)
    	Micropost.where("name LIKE ?", "%#{search}%").order("created_at DESC")
  	end

	def feed
    	#Micropost.where("user_id = ?", id)
    	following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    	Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  	end

	def search_m(search2)
	  where("name LIKE ?", "%#{search2}%") 
	  where("ext LIKE ?", "%#{search2}%")
	end

  	# Follows a user.
	def follow(other_user)
		following << other_user
	end

	# Unfollows a user.
	def unfollow(other_user)
		following.delete(other_user)
	end

	# Returns true if the current user is following the other user.
	def following?(other_user)
		following.include?(other_user)
	end
end
