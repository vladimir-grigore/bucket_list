require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      email: Faker::Internet.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      password: Faker::Internet.password
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it { should validate_presence_of(:email) }

  it { should validate_presence_of(:first_name) }

  it { should validate_presence_of(:last_name) }

  it { should validate_presence_of(:password) }

  context 'with resources added' do
    before do
      subject.save
      create(:activity, user: subject)
    end

    it 'destroys dependent resources' do
      expect { subject.destroy }.to change(Activity, :count).by(-1)
    end
  end
end
