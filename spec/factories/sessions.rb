FactoryGirl.define do
  factory :session do
    user_id ''
    sequence :token do |t|
      "absdf345#{t}a#{t}"
    end
  end
end
