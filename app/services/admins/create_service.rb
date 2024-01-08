module Admins
  class CreateService
    def call(admin)
      Admin.transaction do
        admin.save!

        admin
      end
    end
  end
end
