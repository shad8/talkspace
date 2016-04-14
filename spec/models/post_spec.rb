require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:category) { create(:category) }
  let(:user) { create(:user) }
  let(:params) do
    { title: rand_text, body: rand_text, user: user, category: category }
  end

  it 'is valid' do
    post = Post.new params
    expect(post.save!).to be_truthy
  end

  context 'is invalid' do
    [:title, :body].each do |attribute|
      it "for blank #{attribute}" do
        params[attribute] = ''
        post = Post.new params
        expect(post.save).to be_falsey
      end
    end

    it 'for to short title ' do
      params[:title] = rand_text(3)
      post = Post.new(params)
      expect(post.save).to be_falsey
    end
  end

  context 'has one' do
    let(:post) { Post.create params }

    it 'user' do
      expect(post.user).to eq user
    end

    it 'category' do
      expect(post.category).to eq category
    end
  end
end
