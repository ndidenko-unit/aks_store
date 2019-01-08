class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :trading_days

  enum role: [:block, :seller, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :block
  end

  def admin?
    self.role == "admin"
  end

  def seller?
    self.role == "seller"
  end

end
