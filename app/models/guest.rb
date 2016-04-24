class Guest < User
  after_initialize :set_role

  def owner?(_resource = nil)
    false
  end

  private

  def set_role
    self.role = :guest
  end
end
