class User < ApplicationRecord
  has_many :investments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validates :balance, presence: true
  validates :bitcoin_investment, presence: true
  validates :ether_investment, presence: true
  validates :cardano_investment, presence: true
end
