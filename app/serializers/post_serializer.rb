class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body

  has_one :user, embed: :ids, embed_in_root: :true
end
