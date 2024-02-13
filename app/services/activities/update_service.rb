# frozen_string_literal: true

module Activities
  # Activity update service
  class UpdateService
    def initialize(user:, id:)
      @user = user
      @activity = Activity.find_by(id: id)
    end

    def call(params:)
      Activity.transaction do
        raise ActivityNotFoundError unless @activity
        raise InvalidActivityError unless activity_belongs_to_user?

        @activity.update!(params)

        @activity
      end
    end

    private

    def activity_belongs_to_user?
      @activity.user_id == @user.id
    end

    class ActivityNotFoundError < StandardError; end

    class InvalidActivityError < StandardError; end
  end
end
