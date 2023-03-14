class Merchant < ApplicationRecord
  EMAIL_REGEX = /.+@.+\..+/.freeze
 
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :cif, presence: true, uniqueness: true
end
