FactoryBot.define do
  factory :vote do
    association :player
    association :round
    score { Vote::FIBONACCI_SCORES.sample }
  end
end
