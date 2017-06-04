class AddInexes < ActiveRecord::Migration[5.1]
  def change
  	add_index(:agrements_companies, [:company_id, :agrement_id], unique: true)
  	add_index(:companies_expertises, [:company_id, :expertise_id], unique: true)
  end
end
