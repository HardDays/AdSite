class AddNTypeToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :ntype, :string
  end
end
