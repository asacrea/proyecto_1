class User < ApplicationRecord
	has_many :microposts
	validates :name, presence: true
	validates :email, presence: true
	validates :password_digest, presence: true
	validates :password_digest, presence: true, length: { minimum: 6 }
	has_secure_password
end
