require 'digest'

class User < ApplicationRecord

	validates :email, presence: true, uniqueness: true
	validates :password, presence: true

	has_many :tokens

	has_one :company

	def self.encrypt_password(password)
		return Digest::SHA256.hexdigest(password + 'elite_salt')
	end

	before_create do
		self.password = User.encrypt_password(self.password)
	end

	before_update do
		self.password = User.encrypt_password(self.password)
	end
end
