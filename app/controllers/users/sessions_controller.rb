# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    skip_before_action :verify_signed_out_user
    respond_to :json

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      super do
        render(json: current_user)

        return
      end
    end

    # DELETE /resource/sign_out

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
