module PostsHelper
  def calculate_tag_size(tag)
    min_size = 14
    max_size = 32
    if Post.count == 0
      (max_size + min_size) / 2
    else
      min_size + ((max_size - min_size) * (tag.posts.count / Post.count)).round      
    end
  end
end
