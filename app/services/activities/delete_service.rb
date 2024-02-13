# frozen_string_literal: true

module Activities
  # Activity delete service
  class DeleteService
    def call(user:, id:)
      Activity.transaction do
        activity = user.activities.find_by(id: id)

        raise ActivityNotFoundError unless activity

        activity.destroy!
      end
    end

    class ActivityNotFoundError < StandardError; end
  end
end
