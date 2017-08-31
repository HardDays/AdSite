class Agrement < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	
	has_and_belongs_to_many :companies, dependent: :destroy
	has_and_belongs_to_many :ads, dependent: :destroy
	has_and_belongs_to_many :news, dependent: :destroy

	def serializable_hash options=nil
		super.except("id", "updated_at", "created_at")
  	end
end
