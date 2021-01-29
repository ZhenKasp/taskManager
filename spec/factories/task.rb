FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "task #{n} title" }
    sequence(:body) { |n| "task #{n} body" }

    association :user
  end
end
