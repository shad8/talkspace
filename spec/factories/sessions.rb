FactoryGirl.define do
  factory :session do
    user_id 1
    sequence :token do |t|
      "absdf345#{t}a#{t}"
    end
  end
end
