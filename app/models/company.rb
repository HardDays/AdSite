class Company < ApplicationRecord
	belongs_to :user
	belongs_to :c_type
	belongs_to :sub_category, optional: true

	has_many :rates, dependent: :destroy

	has_and_belongs_to_many :expertises, dependent: :destroy
	has_and_belongs_to_many :agrements, dependent: :destroy

	belongs_to :image, dependent: :destroy

	def serializable_hash options=nil
		attrs = {}
		attrs[:sub_category] = sub_category.name if sub_category.present?
		attrs[:c_type] = c_type.name if c_type.present?
		attrs[:agrements] = agrements.collect{|a| a.name}
		attrs[:expertises] = expertises.collect{|e| e.name}
		@sum = 0
		@cnt = rates.count
		rates.each{|r| @sum += r.rate} if @cnt > 0
		attrs[:rate] = @sum / (@cnt == 0 ? 1 : @cnt)
  		super.merge(attrs)
	end
end
