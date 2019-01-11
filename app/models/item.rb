class Item < ApplicationRecord
  belongs_to :status
  belongs_to :store
  belongs_to :trading_day, optional: true
  belongs_to :user
  belongs_to :client

  validates :name, :retail, :store_id, :status_id, :user_id, presence: true
  validates :retail, numericality: true

  has_paper_trail
 end
