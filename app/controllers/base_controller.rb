# frozen_string_literal: true

# Base controller for APIs
class BaseController < ActionController::API
  before_action :authenticate_user!

  def respond(title, status)
    hash = {
      title: title,
      status: status
    }

    render json: hash, status: status
  end
end
