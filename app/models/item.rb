class Item < ApplicationRecord
  belongs_to :status
  belongs_to :store
  belongs_to :trading_day, optional: true

  validates :name, :purchase, :retail, :store_id, :status_id, presence: true
  validates :purchase, :retail, numericality: true
 end
