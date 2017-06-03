class AddIndexToAccess < ActiveRecord::Migration[5.1]
  def change
  	add_index(:accesses_users, [:access_id, :user_id], unique: true)
  end
end
