FactoryBot.define do
  factory :game do
    owner_name { Faker::Name.name }
    title { Faker::Lorem.sentence }
  end
end
