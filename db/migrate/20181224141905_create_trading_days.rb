class CreateTradingDays < ActiveRecord::Migration[5.2]
  def change
    create_table :trading_days do |t|
      t.integer :day
      t.integer :month
      t.integer :year
      t.float :proceeds
      t.belongs_to :store, index: true

      t.timestamps
    end
  end
end
