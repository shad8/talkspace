def encoded_service_token
  token = 'secret'
  ActionController::HttpAuthentication::Token.encode_credentials(token)
end
