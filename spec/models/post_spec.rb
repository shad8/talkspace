require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:params) do
    { title: rand_text, body: rand_text, user: create(:user) }
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
end
