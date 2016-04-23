FactoryGirl.define do
  factory :user do
    email 'user@example.com'
    login 'example'
    password 'secret'
    role 'user'
  end
end
