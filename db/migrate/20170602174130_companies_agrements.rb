class CompaniesAgrements < ActiveRecord::Migration[5.1]
  def change
  	create_table :agrements_companies, id: false do |t|
      t.belongs_to :company, index: true
      t.belongs_to :agrement, index: true
    end
  end
end
