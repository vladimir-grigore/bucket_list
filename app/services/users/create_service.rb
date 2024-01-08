module Users
  class CreateService
    def call(user)
      User.transaction do
        user.save!

        puts("user: #{user.to_json}")

        user
      end
    end
  end
end
