# frozen_string_literal: true

module Admins
  # Admin create service
  class CreateService
    def call(admin)
      Admin.transaction do
        admin.save!

        admin
      end
    end
  end
end
