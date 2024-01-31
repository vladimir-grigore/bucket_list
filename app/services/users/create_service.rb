# frozen_string_literal: true

module Users
  class CreateService
    def call(user)
      User.transaction do
        user.save!

        user
      end
    end
  end
end
