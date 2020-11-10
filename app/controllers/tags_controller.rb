class TagsController < ApplicationController

  def posts
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.includes(:user).published.ordered.paginate(page: params[:page], per_page: 5)
  end

end
