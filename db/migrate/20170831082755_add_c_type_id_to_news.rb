class AddCTypeIdToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :c_type_id, :integer
  end
end
