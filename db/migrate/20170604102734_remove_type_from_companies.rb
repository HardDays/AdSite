class RemoveTypeFromCompanies < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :type, :string
  end
end
