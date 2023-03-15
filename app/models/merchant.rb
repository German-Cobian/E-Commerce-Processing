class Merchant < ApplicationRecord
  EMAIL_REGEX = /.+@.+\..+/.freeze

  has_many :orders, dependent: :destroy
  has_many :disbursements, dependent: :destroy
 
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :cif, presence: true, uniqueness: true
end
