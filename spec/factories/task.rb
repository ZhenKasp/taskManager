FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "task #{n} title" }
    sequence(:body) { |n| "task #{n} body" }
    due_time DateTime.current + 1.day

    association :user
  end
end
