class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_token

  def self.current_user(token)
    session = find_by(token: token)
    session ? session.user : nil
  end

  private

  def generate_token
    self.token = Digest::SHA512.hexdigest "#{SecureRandom.hex}#{Time.now.to_f}"
  end
end
