class Company < ApplicationRecord
	has_attached_file :logo

	belongs_to :user
	belongs_to :c_type
	belongs_to :sub_category, optional: true

	has_and_belongs_to_many :expertises, dependent: :destroy
	has_and_belongs_to_many :agrements, dependent: :destroy

	def serializable_hash options=nil
		attrs = {c_type: c_type.name}
		if sub_category != nil
			attrs[:sub_category] = sub_category.name
		end
  		super.merge(attrs)
	end
end
