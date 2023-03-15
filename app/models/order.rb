class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :shopper
  belongs_to :disbursement, optional: true

  validates :merchant_id, presence: true
  validates :shopper_id, presence: true
  validates :amount, presence: true, numericality: true
end
