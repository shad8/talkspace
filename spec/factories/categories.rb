FactoryGirl.define do
  factory :category do
    name 'Lorem ipsum'
    user_id 1
    factory :category_with_posts do
      transient do
        posts_count 1
      end

      after(:create) do |category, evaluator|
        create_list(:post, evaluator.posts_count, category: category)
      end
    end
  end
end
