class SubCategory < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	
	has_many :companies
end
