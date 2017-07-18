require 'digest'

class Token < ApplicationRecord
	belongs_to :user, required: true

	before_create do
		self.token = SecureRandom.hex + SecureRandom.hex 
	end

	def is_valid?
		#hours = (Time.now.utc - self.updated_at) / 1.hour
		#return hours <= 24
		return true
	end
end
