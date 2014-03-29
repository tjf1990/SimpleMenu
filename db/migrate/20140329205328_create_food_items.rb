class CreateFoodItems < ActiveRecord::Migration
  def change
    create_table :food_items do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.boolean :is_alcoholic

      t.timestamps
    end
  end
end
