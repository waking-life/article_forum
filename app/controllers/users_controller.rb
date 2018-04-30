class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :comments, :collects, :friends, :check_user, :drafts]
  before_action :check_user, except: [:show, :comments]

    def show
      
      @posts = @user.posts.readable_posts(current_user).open_public
    end

    def edit

    end

    def update
     if @user.update(user_params)
       redirect_to user_path(@user)
     else
       render :action => :edit
     end
    end

    def comments
      @comments = @user.comments.includes(:post)
    end

    def collects
      @collected_posts = @user.collected_posts.includes(:collected_users)
    end

    def drafts
      @drafts = @user.posts.where(public: false)
    end

    def friends
      @friends = @user.all_friends
      @unconfirm_friends = @user.unconfirm_friends
      @request_friends = @user.request_friends
    end

private

     def set_user
      @user = User.find(params[:id])
     end

     def user_params
       params.require(:user).permit(:name, :intro, :avatar)
     end

     def check_user
       unless @user == current_user
         flash[:alert] = "You have no authority！"
         redirect_to user_path(@user)
       end
     end


end
