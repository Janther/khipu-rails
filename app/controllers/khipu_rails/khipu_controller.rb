module KhipuRails
  class KhipuController < KhipuRails::ApplicationController
    def notification
      @notification = {
        api_version:            params[:api_version],
        receiver_id:            params[:receiver_id],
        notification_id:        params[:notification_id],
        subject:                params[:subject],
        amount:                 params[:amount],
        currency:               params[:currency],
        transaction_id:         params[:transaction_id],
        payer_email:            params[:payer_email],
        custom:                 params[:custom],
        notification_signature: params[:notification_signature]
      }

      valid = KhipuRails::NotificationValidator.is_valid?(@notification, :webservice)
      # if valid
      # else
      # end
    end
  end
end
