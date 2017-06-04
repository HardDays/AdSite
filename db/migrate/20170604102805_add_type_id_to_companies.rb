class AddTypeIdToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :type_id, :integer #
  end
end
