class User::PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def index
    @post = Post.new
    @posts = Post.all.order(created_at: :desc)
    @banners = Banner.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @banners = Banner.all
    if @post.save
      redirect_to post_path(@post)
    else
      @user = current_user
      @posts = Post.all
      render :index
    end
  end
  
  def show
    @post_detail = Post.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, post_id: @post_detail.id)
      current_user.view_counts.create(post_id: @post_detail.id)
    end
    @post = Post.find(params[:id])
    @user = @post.user
    @new_post = Post.new
    @post_comment = PostComment.new
    @post_json = @post.attributes.symbolize_keys.select { |k, v| k.match(/id|shop|address|latitude|longitude/) }.to_json
    @banners = Banner.all
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end
  
  def edit
    @post = Post.find(params[:id])
    @banners = Banner.all
  end

  def update
    @post = Post.find(params[:id])
    @banners = Banner.all
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end
  
  private

  def post_params
    params.require(:post).permit(:image, :shop, :caption, :category, :address)
  end
  
  def ensure_correct_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to posts_path
    end
  end
  
end
