class Expense < ApplicationRecord
  belongs_to :trading_day
  belongs_to :user

  validates :sum, numericality: true
  validates :comment, presence: true
end
