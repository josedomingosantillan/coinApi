class User < ApplicationRecord
  has_many :investments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  add_column :balance, :decimal, default: 0.0
  add_column :bitcoin_investment, :decimal, default: 0.0
  add_column :ether_investment, :decimal, default: 0.0
  add_column :cardano_investment, :decimal, default: 0.0

  validates :balance, presence: true
  validates :bitcoin_investment, presence: true
  validates :ether_investment, presence: true
  validates :cardano_investment, presence: true
end
