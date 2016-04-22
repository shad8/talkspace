class ApiVersion
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default || check_headers(request.check_headers)
  end

  private

  def check_headers(headers)
    accept = headers['Accept']
    accept && accept.include?("application/vnd.api.v#{@version}+json")
  end
end
