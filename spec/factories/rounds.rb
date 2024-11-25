FactoryBot.define do
  factory :round do
    association :game
    status { :pending }
    story_title { Faker::Lorem.sentence }
  end
end
