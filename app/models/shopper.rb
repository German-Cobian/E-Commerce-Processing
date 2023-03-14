class Shopper < ApplicationRecord
  EMAIL_REGEX = /.+@.+\..+/.freeze

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :nif, presence: true, uniqueness: true
end
