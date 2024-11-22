FactoryBot.define do
  factory :round do
    association :game
    finished { false }
    story_title { Faker::Lorem.sentence }
  end
end
