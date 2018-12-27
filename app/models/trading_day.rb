class TradingDay < ApplicationRecord
  belongs_to :store
  belongs_to :user
  has_many  :items
  has_many  :expenses

  # validates :store_id, uniqueness: { scope: [:day, :month, :year]}
  # validates [:day, :month, :year], uniqueness: { scope: :store_id }
  # validates_uniqueness_of :id, :scope => [:day, :month, :year, :store_id]

  def proceeds
    self.items.inject(0){|sum,e| sum + e.retail }
  end

  def all_expenses
    self.expenses.inject(0){|sum,e| sum + e.sum }
  end

  def date_and_store
    "#{self.day}/#{self.month}/#{self.year} на #{self.store.name}"
  end
end
