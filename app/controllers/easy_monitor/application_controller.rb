require 'rotp'

module EasyMonitor
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :check_totp_code, if: :totp_required?

    private

    def check_totp_code
      return head :unauthorized unless params[:totp_code]

      totp = ROTP::TOTP.new(EasyMonitor::Engine.totp_secret)
      head :unauthorized unless totp.verify(params[:totp_code])
    end

    def totp_required?
      EasyMonitor::Engine.use_totp
    end
  end
end
