# frozen_string_literal: true

# Base controller for APIs
class BaseController < ActionController::API
  before_action :authenticate_user!
end
