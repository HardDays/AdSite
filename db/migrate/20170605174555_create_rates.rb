class CreateRates < ActiveRecord::Migration[5.1]
  def change
    create_table :rates do |t|
      t.integer :company_id
      t.integer :user_id
      t.float :rate

      t.timestamps
    end
    add_index(:rates, [:company_id, :user_id], unique: true)
  end
end
