class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders, dependent: :destroy

  validates :amount, presence: true, numericality: true
  validates :week, presence: true, uniqueness: { scope: %i[merchant_id year] }, numericality: { only_integer: true }
  validates :year, presence: true, numericality: { only_integer: true }

  class << self
    # This method creates or updates the disbursements for the current year and week
    def process
      Merchant.find_each do |merchant|
        disbursement = find_or_create_disbursement_for(merchant)
        calculate(disbursement)
      end
    end

  
    private

    def find_or_create_disbursement_for(merchant)
      find_or_create_by(merchant_id: merchant.id, year: current_year, week: current_year_week)
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def calculate(disbursement)
      Order.where(merchant_id: disbursement.merchant_id).completed.not_disbursed.in_batches do |batch_query|
        transaction do
          orders = batch_query.select(:amount)
          amount = orders.reduce(disbursement.amount) { |current_amount, order| current_amount + order.net_amount }

          disbursement.update!(amount: amount)
          orders.update_all(disbursement_id: disbursement.id)
        end
      end
    end

    def current_year_week
      Time.current.strftime('%U').to_i
    end

    def current_year
      Time.current.year
    end
  end
end
