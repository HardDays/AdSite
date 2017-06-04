class CType < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	has_many :companies, dependent: :destroy
end
