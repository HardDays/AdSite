class Ad < ApplicationRecord
	belongs_to :user
	belongs_to :c_type, optional: true
	belongs_to :sub_category, optional: true

	has_and_belongs_to_many :expertises, dependent: :destroy
	has_and_belongs_to_many :agrements, dependent: :destroy

	def serializable_hash options=nil
		attrs = {}
		attrs[:sub_category] = sub_category.name if sub_category.present?
		attrs[:c_type] = c_type.name if c_type.present?
		attrs[:agrements] = agrements.collect{|a| a.name}
		attrs[:expertises] = expertises.collect{|e| e.name}
  		super.merge(attrs)
	end
end
