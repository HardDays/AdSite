require 'digest'

class Token < ApplicationRecord
	belongs_to :user, required: true

	before_create do
		self.token = SecureRandom.hex + SecureRandom.hex 
	end

	def self.is_valid?(token)
		if token != nil
			hours = (Time.now.utc - token.updated_at) / 1.hour
			if hours > 24
				token.destroy
				return false
			end
			return true
		end
		return false
	end
end
