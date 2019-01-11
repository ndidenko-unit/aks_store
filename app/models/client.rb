class Client < ApplicationRecord
  has_many :items

  validates :name, :phone, :discount, presence: true
  validates :discount, inclusion: 0..100

end