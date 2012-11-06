class UsersController < ApplicationController

  include UsersHelper

  before_filter :authenticate, :except => [:new, :create]
  before_filter :is_not_authenticate, :only => [:new, :create]
  before_filter :correct_user?, :only => [:edit, :update]
  before_filter :boss?, :only => [:index]

  def index
    @title = "All users"
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @title = @user.full_name
  end

  def new
    @title = "Sign up"
    @submit_value = "Sign up"
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    @submit_value = "Save"
    @title = "Edit user"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Shop!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    @users = User.all
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private

  def access_for_create_user
    if signed_in?
      redirect_back_or root_path
    end
  end


  def boss?
    flash[:notice] = "You don't have permision to this page"
    redirect_to(root_path)
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:notice] = "You don't have permision to this page"
      redirect_to(root_path)
    end
  end

end
