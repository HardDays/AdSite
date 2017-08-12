class UsersController < ApplicationController  
  before_action :authorize_index, only: [:index]
  before_action :authorize_show, only: [:show]
  before_action :authorize_update, only: [:update]
  before_action :authorize_delete, only: [:delete]
  before_action :authorize_rate, only: [:rate, :like]

  # POST /users/rate
  def rate
    @user = User.find(params[:user_id])
    if @user.company == nil
      render status: :unprocessable_entity and return
    end
    
    @rate = Rate.new(user_id: @from.id, company_id: @user.company.id, rate: params[:rate])
    begin
      if @rate.save
        render status: :ok
      else
        render json: @rate.errors, status: :unprocessable_entity
      end
    rescue Exception
        render status: :conflict 
    end
  end

  # POST /users/like
  def like
    @user = User.find(params[:user_id])
    if @user.company == nil
      render status: :unprocessable_entity and return
    end

    if Like.find_by(user_id: @from.id, company_id: @user.company.id) != nil
      render status: :conflict and return
    end
    
    @like = Like.new(user_id: @from.id, company_id: @user.company.id)
    begin
      if @like.save
        render status: :ok
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    rescue Exception
        render status: :conflict 
    end
  end

  def filter_one(param)
    if @users != nil
      @users = @users.or(Company.where(param))
    else
      @users = Company.where(param)
    end
  end

   def filter_two(param1, param2)
    if @users != nil
      @users = @users.or(Company.where(param1, param2))
    else
      @users = Company.where(param1, param2)
    end
  end

  def filter_join(param)
    if @users != nil
      @users = @users.joins(param).where(param => {name: params[param]})
    else
      @users = Company.joins(param).where(param => {name: params[param]})
    end
  end

  # GET /users/all
  def index

    @users = nil
    
    filter_two("companies.name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    filter_two("address LIKE ?", "%#{params[:address]}%") if params[:address].present?
    filter_two("other_address LIKE ?", "%#{params[:other_address]}%") if params[:other_address].present?
    filter_two("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
    filter_two("opening_times LIKE ?", "%#{params[:opening_times]}%") if params[:opening_times].present?
    filter_two("company_id LIKE ?", "%#{params[:company_id]}%") if params[:company_id].present?

    #filter by type
    if params[:c_type].present?
      @type = CType.find_by(name: params[:c_type])
      if @users != nil
        @users = @users.or(Company.where(c_type_id: @type.id))
      else
        @users = Company.where(c_type_id: @type.id)
      end
    end
    #filter by category
    if params[:sub_categories].present?
      ids = []
      for sub_cat in params[:sub_categories]
        ids.push(SubCategory.find_by(name: sub_cat))
      end
      ids = ids.collect{|e|e.id}
      if @users != nil
        @users = @users.or(Company.where(sub_category_id: ids))
      else
        @users = Company.where(sub_category_id: ids)
      end
    end

    #filter by expertise
    @users = filter_join(:expertises) if params[:expertises].present?
    #filter by agrement
    @users = filter_join(:agrements) if params[:agrements].present?
    #get all if no filters
    @users = Company.all if @users == nil

    #limit, offset
    total = @users.count
    @users = @users.offset(params[:offset]).limit(params[:limit])

    @users = @users.collect{|e| e.user} if @users != nil
    render json: {users: @users, total_count: total}
  end

  # GET /users/all
  # def index
  #   @users = nil #User.all

  #   @filters = ['first_name', 'last_name', 'email']
  #   @filters.each do |filter|
  #     if @users == nil
  #        @users = User.where("#{filter} ILIKE ?", "%#{params[filter]}%") if params[filter] != nil
  #     else
  #        @users = @users.or(User.where("#{filter} ILIKE ?", "%#{params[filter]}%")) if params[filter] != nil
  #     end
  #   end
  #   @users = User.all if @users == nil

  #   @users = @users.limit(params[:limit]).offset(params[:offset])

  #   render json: {users: @users, total_count: @users.count}, except: :password
  # end

  # GET /users/info/:id
  def show
    @user = User.find(params[:id])
    render json: @user, except: :password
  end

  # GET /users/my_info
  def my_info
    @user = AuthorizeController.authorize(request)
    if @user != nil
      render json: @user, except: :password
    else
      render status: :unauthorized
    end
  end

  # POST /users/create
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
      if params[:company][:sub_category] != nil
        @company.sub_category = SubCategory.find_by name: params[:company][:sub_category]
      end
      #add type
      if params[:company][:c_type] != nil
        @company.c_type = CType.find_by name: params[:company][:c_type]
      end
      #add image
      if params[:company][:base64] != nil
        @image = Image.new(base64: params[:company][:base64])
        @image.save
        @company.image = @image
      end
      #create company
      @ok = true
      if !@company.save
        @user.destroy
        render json: @company.errors, status: :unprocessable_entity and return
      end
      #many-to-many agrements
      if params[:agrements] != nil
        @ok = @ok and AgrementController.set_company_agrements(@company, params[:agrements])
      end
      #many-to-many expretises
      if params[:expertises] != nil
        @ok = @ok and ExpertiseController.set_company_expertises(@company, params[:expertises])
      end
      #grant access to post ads
      @ok = @ok and AccessController.grant_enterprises_access(@user)
      #check error
      if not @ok
        @user.destroy
        @company.destroy
        render status: :unprocessable_entity and return
      else
        render json: @user, except: :password, status: :created
      end
    else
      #give client access
      if not AccessController.grant_client_access(@user)
        @user.destroy
        render status: :unprocessable_entity and return
      end
      render json: @user, except: :password, status: :created
    end 
  end 

  # PUT /users/update/:id
  def update
    @user = User.find(params[:id])
    @password = params[:user][:password]
    if @password != nil
      params[:user][:password] = User.encrypt_password(@password)
    end
    #update user
    if !@user.update(user_params)
      render json: @user.errors, status: :unprocessable_entity and return
    end

    #update company
    if params[:company] != nil
      @company = Company.find_by user_id: @user.id
      #add sub-category
      if params[:company][:sub_category] != nil
        @company.sub_category = SubCategory.find_by name: params[:company][:sub_category]
      end
      #add type
      if params[:company][:c_type] != nil
        @company.c_type = CType.find_by name: params[:company][:c_type]
      end
      #add image
      if params[:company][:base64] != nil
        @image = Image.new(base64: params[:company][:base64])
        @image.save
        @company.image = @image
      end
      if !@company.update(company_params)
        #many-to-many agrements
        if params[:agrements] != nil
          AgrementController.set_company_agrements(@company, params[:agrements])
        end
        #many-to-many expretises
        if params[:expertises] != nil
          ExpertiseController.set_company_expertises(@company, params[:expertises])
        end

        render json: @company.errors, status: :unprocessable_entity and return
      end
      render json: @user, except: :password, status: :updated
      end
    end

  # DELETE /users/delete/:id
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :phone)
    end

    def company_params
      params.require(:company).permit(:name, :logo, :address, :other_address, :email, :phone, :opening_times, :company_id, :description, :links, :user_id)
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

    def authorize_rate
      @from = AuthorizeController.authorize(request)
      if @from == nil or not @from.has_access?(:can_rate)
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
