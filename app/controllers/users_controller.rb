class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]
  
  before_action :authorize_index, only: [:index]
  before_action :authorize_show, only: [:show]
  before_action :authorize_update, only: [:update]
  before_action :authorize_delete, only: [:delete]

  # GET /users
  def index
    @users = User.all
    render json: @users, except: :password
  end

  # GET /users/1
  def show
    render json: @user, except: :password
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, except: :password, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user, except: :password
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :phone)
    end

    def authorize(access)
      if not AuthorizeController.authorize_access(request, access)
        render status: :unauthorized
      end
    end

    def authorize_self(access)
      set_user
      if not AuthorizeController.authorize_self(request, access, @user)
        render status: :unauthorized
      end
    end

    def authorize_index
      authorize(:can_view_users)
    end

    def authorize_show
      authorize_self(:can_view_users)
    end

    def authorize_update
       authorize_self(:can_update_users)
    end

    def authorize_delete
       authorize(:can_delete_users)
    end
end
