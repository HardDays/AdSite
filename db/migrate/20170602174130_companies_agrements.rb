class CompaniesAgrements < ActiveRecord::Migration[5.1]
  def change
  	create_table :companies_agrements, id: false do |t|
      t.belongs_to :company, index: true
      t.belongs_to :agrement, index: true
    end
  end
end
