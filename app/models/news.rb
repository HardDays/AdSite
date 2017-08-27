class News < ApplicationRecord
    belongs_to :user
    belongs_to :image, optional: true, dependent: :destroy

    validates_inclusion_of :ntype, in: ['standart', 'premium', nil]
    validates_inclusion_of :ncategory, in: ['toutes', 'finance', 'ecologique', 'immobilier', 'plaisir', nil]

end
