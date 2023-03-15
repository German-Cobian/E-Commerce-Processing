module Api
  module V1
    class DisbursementsController < ApplicationController
      def index
        @disbursements = Disbursement.where(safe_params)
        render json: @disbursements
      end

      private

      def safe_params
        params.permit(:year, :week, :merchant_id)
      end
    end
  end
end
