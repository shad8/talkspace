class User < ApplicationRecord
  has_secure_password

  has_many :posts
  has_many :categories
  has_many :sessions

  validates :login, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }

  enum role: [:user, :admin]

  attr_accessor :token
end
