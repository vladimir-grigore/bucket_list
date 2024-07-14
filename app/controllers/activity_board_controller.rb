# frozen_string_literal: true

# Controller for interacting with public activities
class ActivityBoardController < BaseController
  def index
    render json: Activity.visible
  end

  def show
    render json: Activity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond(I18n.t('errors.messages.generic.404'), 404)
  end
end
