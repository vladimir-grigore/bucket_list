# frozen_string_literal: true

module Users
  # User create service
  class CreateService
    def call(user)
      User.transaction do
        user.save!

        user
      end
    end
  end
end
