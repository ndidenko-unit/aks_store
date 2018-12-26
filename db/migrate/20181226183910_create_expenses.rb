class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.float :sum
      t.string :comment
      t.belongs_to :trading_day, index: true
      t.timestamps
    end
  end
end
