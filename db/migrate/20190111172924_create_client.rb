class CreateClient < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :phone
      t.integer :discount, default: 5
    end
  end
end
