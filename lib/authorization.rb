class Authorization
  def initialize(token, resource)
    @token = token
    @user = set_user
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

  def set_user
    session = Session.find_by(token: @token)
    session ? session.user : nil
  end
end
