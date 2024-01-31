# frozen_string_literal: true

RSpec.shared_context 'with authenticated user' do
  let(:user_sign_in_url) { '/users/sign_in' }
  let(:user) { Users::CreateService.new.call(build(:user)) }

  let(:sign_in_params) do
    {
      user: {
        email: user.email,
        password: user.password,
      },
    }
  end

  before do
    post user_sign_in_url, params: sign_in_params
  end
end
