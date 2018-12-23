class Item < ApplicationRecord
  belongs_to :status
  belongs_to :store

  validates :name, :purchase, :retail, :store_id, :status_id, presence: true
  validates :purchase, :retail, numericality: true
 end
