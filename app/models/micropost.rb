class Micropost < ApplicationRecord
	belongs_to :user
	default_scope -> { order(created_at: :desc) }
	mount_uploader :picture, PictureUploader
  	validates :name, length: { maximum: 140 },
                     presence: true
	validates :user_id, presence: true
	validates :ext, presence: true
	validates :size, presence: true
	validate  :picture_size

	private

		# Validates the size of an uploaded picture.
	    def picture_size
	      if picture.size > 5.megabytes
	        errors.add(:picture, "should be less than 5MB")
	      end
	    end
end
