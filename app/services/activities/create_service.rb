# frozen_string_literal: true

module Activities
  # Activity create service
  class CreateService
    def call(user:, params:)
      Activity.transaction do
        activity = Activity.create!(
          user: user,
          name: params[:name],
          description: params[:description],
          public: params[:public],
          deadline: params[:deadline]
        )

        activity.save!

        activity
      end
    end
  end
end
