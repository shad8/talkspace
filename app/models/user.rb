class User < ApplicationRecord
  has_secure_password

  has_many :posts
  has_many :categories
  has_many :sessions

  validates :login, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }

  enum role: [:user, :admin]

  before_create :generate_token

  private

  def generate_token
    self.token = Digest::SHA512.hexdigest "#{SecureRandom.hex}#{Time.now.to_f}"
  end
end
