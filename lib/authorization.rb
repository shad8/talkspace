class Authorization
  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def permitted
    @user && role_allow
  end

  private

  def role_allow
    admin || owner
  end

  def admin
    @user.admin?
  end

  def owner
    @resource ? (@resource.user == @user) : true
  end
end
