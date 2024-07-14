# frozen_string_literal: true

# Controller for creating user activities
class ActivitiesController < BaseController
  def create
    activity = Activities::CreateService.new.call(user: current_user, params: activities_params)

    render json: activity, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { title: e.message }, status: :unprocessable_entity
  end

  def show
    render json: current_user.activities.find(params[:id]), status: :ok
  rescue ActiveRecord::RecordNotFound
    respond(I18n.t('errors.messages.generic.404'), 404)
  end

  def index
    render json: current_user.activities, status: :ok
  end

  def update
    activity = Activities::UpdateService.new(user: current_user, id: params[:id]).call(params: activities_params)

    render json: activity, status: :ok
  rescue Activities::UpdateService::ActivityNotFoundError,
         Activities::UpdateService::InvalidActivityError
    respond(I18n.t('errors.messages.generic.404'), 404)
  end

  def destroy
    Activities::DeleteService.new.call(user: current_user, id: params[:id])
  rescue Activities::DeleteService::ActivityNotFoundError
    respond(I18n.t('errors.messages.generic.404'), 404)
  end

  private

  def activities_params
    params.permit(:name, :description, :public, :deadline)
  end
end
