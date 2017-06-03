class Company < ApplicationRecord
	has_attached_file :logo

	belongs_to :user
	belongs_to :sub_category
	#kek
	has_and_belongs_to_many :expertises
	has_and_belongs_to_many :agrements

end
