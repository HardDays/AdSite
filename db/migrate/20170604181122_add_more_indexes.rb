class AddMoreIndexes < ActiveRecord::Migration[5.1]
  def change
  	add_index(:ads_agrements, [:ad_id, :agrement_id], unique: true)
  	add_index(:ads_expertises, [:ad_id, :expertise_id], unique: true)
  end
end
