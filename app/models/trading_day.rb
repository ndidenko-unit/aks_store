class TradingDay < ApplicationRecord
  belongs_to :store
  belongs_to :user
  has_many  :items
  has_many  :expenses

  # validates :store_id, uniqueness: { scope: [:day, :month, :year]}
  # validates [:day, :month, :year], uniqueness: { scope: :store_id }
  # validates_uniqueness_of :scopes => [:day, :month, :year, :store_id]
  validate :equal_trading_day, :not_closed_day, on: [:create]
  validate :update_equal_trading_day, on: [:update]

  def previously_proceeds
    self.items.inject(0){|sum,e| sum + e.retail }
  end

  def all_expenses
    self.expenses.inject(0){|sum,e| sum + e.sum }
  end

  def date_and_store
    "#{self.day}/#{self.month}/#{self.year} на #{self.store.name}"
  end

  def status
    if self.proceeds == nil
      'Выручка не сдана'
    else
      "Выручка сдана: #{self.proceeds} грн."
    end
  end

  def close?
    self.proceeds != nil
  end

  def unblock
    self.update(proceeds: nil)
  end

  private

  def not_closed_day
    if TradingDay.where(user_id: self.user_id, proceeds: nil).present?
      errors.add(:base, 'У вас есть незакрытые торговые дни')
    end
  end

  def equal_trading_day
    if TradingDay.where(day: day, month: month, year: year, store_id: store_id).present?
      errors.add(:base, 'Такой торговый день уже существует')
    end
  end

  def update_equal_trading_day
    trading_day = TradingDay.where(day: day, month: month, year: year, store_id: store_id)
    return if !trading_day.present?
    if TradingDay.where(day: day, month: month, year: year, store_id: store_id).first.id != self.id
      errors.add(:base, 'Такой торговый день уже существует')
    end
  end
end
