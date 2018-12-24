class Store < ApplicationRecord
  has_many :items
  has_many :trading_days

  validates :name, presence: true
end
