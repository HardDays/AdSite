class AddLogoToCompany < ActiveRecord::Migration[5.1]
  def up
    add_attachment :companies, :logo
  end

  def down
    remove_attachment :companies, :logo
  end
end
