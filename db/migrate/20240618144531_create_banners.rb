class CreateBanners < ActiveRecord::Migration[6.1]
  def change
    create_table :banners do |t|
      t.string :url
      t.boolean :visible
      
      t.timestamps
    end
  end
end
