class CreateTables < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :instructions
      t.integer :rating
      t.timestamps null: false
    end

    create_table :ingredients do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :quantities do |t|
      t.string :description
      t.belongs_to :ingredient, index: true
      t.belongs_to :recipe, index: true
      t.timestamps null: false
    end

    create_table :tags do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :recipes_tags do |t|
      t.belongs_to :recipe, index: true
      t.belongs_to :tag, index: true
    end
  end
end
