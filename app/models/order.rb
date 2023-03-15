class Order < ApplicationRecord
  FIRST_SECTION = 50
  SECOND_SECTION = 300

  FIRST_SECTION_FEE = 0.01
  SECOND_SECTION_FEE = 0.0095
  THIRD_SECTION_FEE = 0.0085

  belongs_to :merchant
  belongs_to :shopper
  belongs_to :disbursement, optional: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :not_disbursed, -> { where(disbursement_id: nil) }

  validates :amount, presence: true, numericality: true

   # Calculates amount to be paid after apply fees
   def net_amount
    if amount < FIRST_SECTION
      amount * (1 - FIRST_SECTION_FEE)
    elsif amount < SECOND_SECTION
      amount * (1 - SECOND_SECTION_FEE)
    else
      amount * (1 - THIRD_SECTION_FEE)
    end
  end
end
