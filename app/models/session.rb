class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_token

  private

  def generate_token
    self.token = Digest::SHA512.hexdigest "#{SecureRandom.hex}#{Time.now.to_f}"
  end
end
