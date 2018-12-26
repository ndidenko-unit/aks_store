class TradingDay < ApplicationRecord
  belongs_to :store
  belongs_to :user
  has_many :items
  has_many  :expenses

  def proceeds
    self.items.inject(0){|sum,e| sum + e.retail }
  end
end
