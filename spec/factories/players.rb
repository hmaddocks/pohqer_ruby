FactoryBot.define do
  factory :player do
    association :game
    name { Faker::Name.name }
  end
end
