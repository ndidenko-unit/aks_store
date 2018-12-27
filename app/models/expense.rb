class Expense < ApplicationRecord
  belongs_to :trading_day

  validates :sum, numericality: true
  validates :comment, presence: true
end
