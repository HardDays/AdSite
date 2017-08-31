class ExpertisesNews < ActiveRecord::Migration[5.1]
  def change
    create_table :expertises_news, id: false do |t|
      t.belongs_to :news, index: true
      t.belongs_to :expertise, index: true
    end
  end
end
