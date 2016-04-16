require 'rails_helper'

RSpec.describe User, type: :model do
  let(:params) do
    { login: rand_text, password: 'secret', email: rand_text }
  end

  subject { User.new params }

  it 'is valid' do
    expect(subject.save!).to be_truthy
  end

  context 'is invalid' do
    [:login, :email, :password].each do |attribute|
      it "for blank #{attribute}" do
        params[attribute] = ''
        user = User.new params
        expect(user.save).to be_falsey
      end
    end

    it 'for to short password ' do
      params[:password] = rand_text(3)
      user = User.new(params)
      expect(user.save).to be_falsey
    end

    it 'for not unique login' do
      params[:login] = create(:user).login
      user = User.new(params)
      expect(user.save).to be_falsey
    end

    it 'for not unique email' do
      params[:email] = create(:user).email
      user = User.new(params)
      expect(user.save).to be_falsey
    end
  end

  context 'has_many' do
    it 'posts' do
      user = User.create params
      expect(user.posts).to be
    end

    it 'categories' do
      user = User.create params
      expect(user.posts).to be
    end

    it 'sessions' do
      user = User.create params
      expect(user.posts).to be
    end
  end

  context 'has role' do
    it 'default :user' do
      expect(subject.user?).to be_truthy
    end

    it ':admin' do
      subject.role = :admin
      expect(subject.admin?).to be_truthy
    end
  end
end
