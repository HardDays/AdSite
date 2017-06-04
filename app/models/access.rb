class Access < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	has_and_belongs_to_many :users, dependent: :destroy

	def serializable_hash options=nil
		super.except("id", "updated_at", "created_at")
  	end
end
