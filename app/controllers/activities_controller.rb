# frozen_string_literal: true

class ActivitiesController < BaseController
  def create
    activity = Activities::CreateService.new.call(user: current_user, params: activities_params)

    render json: activity, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { title: e.message }, status: :unprocessable_entity
  end

  private

  def activities_params
    params.permit(:name, :description, :public, :deadline)
  end
end
