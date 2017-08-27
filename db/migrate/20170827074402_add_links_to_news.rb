class AddLinksToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :links, :string
  end
end
