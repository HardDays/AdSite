class AgrementsNews < ActiveRecord::Migration[5.1]
  def change
    create_table :agrements_news, id: false do |t|
      t.belongs_to :news, index: true
      t.belongs_to :agrement, index: true
    end
  end
end
