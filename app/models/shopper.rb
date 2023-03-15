class Shopper < ApplicationRecord
  EMAIL_REGEX = /.+@.+\..+/.freeze

  has_many :orders, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :nif, presence: true, uniqueness: true
end
