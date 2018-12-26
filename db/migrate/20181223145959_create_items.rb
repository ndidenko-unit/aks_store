class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.float :purchase
      t.float :retail
      t.belongs_to :status, index: true
      t.belongs_to :store, index: true
      t.belongs_to :trading_day, index: true
      t.timestamps
    end
  end
end
