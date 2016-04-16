FactoryGirl.define do
  factory :user do
    email 'user@example.com'
    login 'example'
    password 'secret'
    role 'user'
    factory :user_with_sessions do
      transient do
        sessions_count 1
      end

      after(:create) do |user, evaluator|
        create_list(:session, evaluator.sessions_count, user: user)
      end
    end
  end
end
