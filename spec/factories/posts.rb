FactoryGirl.define do
  factory :post do
    title 'Lorem ipsum'
    body 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
    user
  end
end
