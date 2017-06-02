class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :other_address
      t.string :email
      t.string :phone
      t.time :opening_times
      t.string :type
      t.string :company_id
      t.string :description
      t.string :links

      t.timestamps
    end
  end
end
