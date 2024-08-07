class User::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @post = Post.new
    @groups = Group.all
    @join_groups = current_user.groups
    @owned_groups = current_user.owned_groups 
    @banners = Banner.all
  end

  def show
    @post = Post.new
    @group = Group.find(params[:id])
    @banners = Banner.all
  end

  def new
    @group = Group.new
    @post = Post.new
    @banners = Banner.all
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @banners = Banner.all
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
    @post = Post.new
    @banners = Banner.all
  end

  def update
    @banners = Banner.all
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end
  
  def destroy
    group = Group.find(params[:id])
    group.destroy
    redirect_to groups_path
  end
  
  def new_mail
    @group = Group.find(params[:group_id])
    @post = Post.new
    @banners = Banner.all
  end

  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    @post = Post.new
    @banners = Banner.all
    if validate_mail(@mail_title, @mail_content)
      begin
        ContactMailer.send_mail(@mail_title, @mail_content, group_users).deliver_now
      rescue => e
        flash[:alert] = "メールの送信に失敗しました: #{e.message}"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:alert] = "メールのタイトルまたは内容が不正です。"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

  def validate_mail(title, content)
    title.present? && title.length <= 50 && content.present? && content.length <= 500
  end
end
