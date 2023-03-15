# frozen_string_literal: true

namespace :disbursements do
  task process: :environment do
    p 'Processing disbursements'
    Disbursement.process
    p 'Disbursements processor finished'
  end
end
