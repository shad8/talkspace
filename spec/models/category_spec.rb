require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:params) do
    { name: rand_text, user: create(:user) }
  end

  it 'is valid' do
    category = Category.new params
    expect(category.save!).to be_truthy
  end

  context 'invalid for' do
    it 'blank name' do
      params[:name] = ''
      category = Category.new params
      expect(category.save).to be_falsey
    end
  end

  it 'has_many posts' do
    category = Category.create params
    expect(category.posts).to eq []
  end

  it 'belongs_to user' do
    category = Category.create params
    expect(category.user).to be
  end
end
