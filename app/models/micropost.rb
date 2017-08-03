class Micropost < ApplicationRecord
	belongs_to :user
  	validates :name, length: { maximum: 140 },
                     presence: true
end
