class UsersController < ApplicationController  
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
    @user = User.find(params[:id])
    render json: @user, except: :password
  end

  # POST /users
  def create
    #create user
    @user = User.new(user_params)
    if !@user.save
      render json: @user.errors, status: :unprocessable_entity and return
    end

    if params[:company] != nil
      #create company
      @company = Company.new(company_params)
      @company.user_id = @user.id
      #add category
      if params[:sub_category] != nil
        @company.sub_category = SubCategory.find_by name: params[:sub_category]
      end
      #add type
      if params[:c_type] != nil
        @company.c_type = CType.find_by name: params[:c_type]
      end
      #create company
      @ok = true
      if !@company.save
        @user.destroy
        render json: @company.errors, status: :unprocessable_entity and return
      end
      #many-to-many agrements
      if params[:agrements] != nil
        @ok = @ok and AgrementController.set_agrements(@company, params[:agrements])
      end
      #many-to-many expretises
      if params[:expertises] != nil
        @ok = @ok and ExpertiseController.set_expertises(@company, params[:expertises])
      end
      #grant access to post ads
      @ok = @ok and AccessController.grant_enterprises_access(@user)
      #check error
      if not @ok
        @user.destroy
        @company.destroy
        render status: :unprocessable_entity and return
      else
        render json: @user, except: :password, status: :created, location: @user
      end
    else
      #give client access
      if not AccessController.grant_client_access(@user)
        @user.destroy
        render status: :unprocessable_entity and return
      end
      render json: @user, except: :password, status: :created, location: @user
    end 
  end

  def update
    @user = User.find(params[:user][:id])
    @company = Company.find(params[:company][:id])
    #update user
    if !@user.update(user_params)
      render json: @user.errors, status: :unprocessable_entity and return
    end
     #update company
    if !@company.update(company_params)
      render json: @company.errors, status: :unprocessable_entity and return
    end
    render json: @user, except: :password, status: :updated
    end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  private
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
      @user = User.find(params[:id])
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
