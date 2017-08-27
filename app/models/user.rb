require 'digest'

class User < ApplicationRecord

	validates :email, presence: true, uniqueness: true
	validates :password, presence: true, length: {:within => 6..40}

	has_many :tokens, dependent: :destroy
	has_many :ads, dependent: :destroy
	has_many :rates, dependent: :destroy
	has_many :likes, dependent: :destroy
	has_many :news, dependent: :destroy

	has_one :company, dependent: :destroy

	has_and_belongs_to_many :accesses, dependent: :destroy
	
	validates_inclusion_of :pcategory, in: ['tous', 'assureurs', 'avocats', 'patrimoine', 'prets', 
											'comptables', 'notaires', 'immobilier', nil]


	def self.encrypt_password(password)
		return Digest::SHA256.hexdigest(password + 'elite_salt')
	end

	before_create do
		self.password = User.encrypt_password(self.password)
	end

	def has_access?(access_name)
		@access = self.accesses.find{|a| a.name == access_name.to_s}
		return @access != nil ? true : false
	end

	def serializable_hash options=nil
		#attrs = {access: accesses}
		attrs = {}
		if company != nil
			attrs[:company] = company
  		end
  		super.merge(attrs)
	end
end
