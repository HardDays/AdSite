class AddSubtitleToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :subtitle, :string
  end
end
