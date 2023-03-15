class Disbursement < ApplicationRecord
  belongs_to :merchant

  has_many :orders, dependent: :destroy

  validates :amount, presence: true, numericality: true
  validates :week, uniqueness: { scope: %i[merchant_id year] }, numericality: { only_integer: true }
  validates :year, numericality: { only_integer: true }

  before_validation :set_week_and_year

  private

  def set_week_and_year
    self.week ||= Time.current.strftime('%U').to_i
    self.year ||= Time.current.year
  end

end
