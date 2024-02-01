# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    name { 'MyString' }
    description { 'MyText' }
    user { create(:user) }
    public { true }
    deadline { '2024-01-09 03:30:05' }
  end

  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password }
  end

  factory :admin do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password }
  end
end
