class CType < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	has_many :companies, dependent: :destroy

	def serializable_hash options=nil
		super.except("id", "updated_at", "created_at")
  	end
end
