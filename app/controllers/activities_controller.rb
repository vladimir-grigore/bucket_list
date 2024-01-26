class ActivitiesController < BaseController
  def create
    user = Activities::CreateService.new.call(params: activities_params)

    render json: user, status: :created
  end

  private

  def activities_params
    params.permit(:name, :description, :public, :deadline)
  end
end
