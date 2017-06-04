class CreateAds < ActiveRecord::Migration[5.1]
  def change
    create_table :ads do |t|
      t.string :title
      t.string :description
      t.string :address
      t.integer :user_id
      t.integer :c_type_id
      t.integer :sub_category_id

      t.timestamps
    end
  end
end
