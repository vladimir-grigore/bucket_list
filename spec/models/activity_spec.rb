require 'rails_helper'

RSpec.describe Activity, type: :model do
  let(:user) { create(:user) }

  subject do
    described_class.new(
      user: user,
      name: 'Climb Everest',
      description: 'I want to see the top of the world',
      public: true,
      deadline: '12/09/2067'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is correctly associated with the user' do
    subject.save
    expect(user.activity_ids.first).to eq(subject.id)
  end

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:description) }

  it { should validate_presence_of(:public) }

  it { should validate_presence_of(:deadline) }
end
