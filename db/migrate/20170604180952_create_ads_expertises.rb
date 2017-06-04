class CreateAdsExpertises < ActiveRecord::Migration[5.1]
  def change
    create_table :ads_expertises do |t|
      t.integer :ad_id
      t.integer :expertise_id
    end
  end
end
