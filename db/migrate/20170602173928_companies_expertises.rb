class CompaniesExpertises < ActiveRecord::Migration[5.1]
  def change
  	create_table :companies_expertises, id: false do |t|
      t.belongs_to :company, index: true
      t.belongs_to :expertise, index: true
    end
  end
end
