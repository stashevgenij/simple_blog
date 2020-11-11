module PostsHelper
  def calculate_tag_size(tag)
    min_size = 18
    max_size = 36
    if Post.count.zero?
      (max_size + min_size) / 2
    else
      min_size + ((max_size - min_size) * (tag.posts.count.to_f / Post.count)).round
    end
  end
end
