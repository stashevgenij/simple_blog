class PostsController < ApplicationController
  before_action :require_valid_user!, except: [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy]

  caches_page :index
  caches_action :show

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.includes(:user).published.ordered.paginate(page: params[:page], per_page: 5)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    if user_signed_in?
      @post = current_user.posts.or(Post.published).find(params[:id])      
    else
      @post = Post.published.find(params[:id])
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_posts
    @posts = current_user.posts.includes(:user).ordered.paginate(page: params[:page], per_page: 5)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = current_user.posts.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :do_not_publish, :created_at)
    end
end
