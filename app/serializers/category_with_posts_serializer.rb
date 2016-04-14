class CategoryWithPostsSerializer < CategorySerializer
  has_many :posts, embed: :ids, embed_in_root: :true
end
