class News < ApplicationRecord
    belongs_to :user
    belongs_to :image, optional: true, dependent: :destroy

    belongs_to :c_type, optional: true
	belongs_to :sub_category, optional: true

	has_and_belongs_to_many :expertises, dependent: :destroy
	has_and_belongs_to_many :agrements, dependent: :destroy

    validates_inclusion_of :ntype, in: ['standart', 'premium', nil]
    validates_inclusion_of :ncategory, in: ['toutes', 'finance', 'ecologique', 'immobilier', 'plaisir', nil]

    def serializable_hash options=nil
		attrs = {}
		attrs[:sub_category] = sub_category.name if sub_category.present?
		attrs[:c_type] = c_type.name if c_type.present?
		attrs[:agrements] = agrements.collect{|a| a.name}
		attrs[:expertises] = expertises.collect{|e| e.name}
		attrs[:user_first_name] = user.first_name if user.present?
		attrs[:user_last_name] = user.last_name if user.present?
  		super.merge(attrs)
	end
end
