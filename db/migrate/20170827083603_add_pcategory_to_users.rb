class AddPcategoryToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pcategory, :string
  end
end
