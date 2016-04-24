def encoded_service_token(token)
  ActionController::HttpAuthentication::Token.encode_credentials(token)
end
