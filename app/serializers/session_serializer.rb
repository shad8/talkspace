class SessionSerializer < ActiveModel::Serializer
  attributes :user_id, :token
end
