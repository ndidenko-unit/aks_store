class Item < ApplicationRecord
  belongs_to :status
  belongs_to :store
end
