class AdsController < ApplicationController
  before_action :set_ad, only: [:show, :update, :destroy]
  before_action :authorize_create, only: [:create]
  before_action :authorize_index, only: [:index]
  before_action :authorize_show, only: [:show]
  before_action :authorize_update, only: [:update]
  before_action :authorize_delete, only: [:delete]

  def filter_one(param)
    if @ads != nil
      @ads = @ads.where(param)
    else
      @ads = Ad.where(param)
    end
  end

   def filter_two(param1, param2)
    if @ads != nil
      @ads = @ads.where(param1, param2)
    else
      @ads = Ad.where(param1, param2)
    end
  end

  def filter_join(param)
    if @ads != nil
      @ads = @ads.joins(param).where(param => {name: params[param]})
    else
      @ads = Ad.joins(param).where(param => {name: params[param]})
    end
  end

  # GET /ads/all
  def index
    filter_two("title LIKE ?", "%#{params[:title]}%") if params[:title].present?
    filter_two("description LIKE ?", "%#{params[:description]}%") if params[:description].present?
    filter_two("address LIKE ?", "%#{params[:address]}%") if params[:address].present?
    #filter by type
    if params[:c_type].present?
      @type = CType.find_by(name: params[:c_type])
      filter_one(c_type_id: @type.id)
    end
    #filter by category
    if params[:sub_category].present?
      @type = SubCategory.find_by(name: params[:sub_category])
      filter_one(sub_category_id: @type.id)
    end
    #filter by author
    @ads = filter_one(user_id: params[:user_id]) if params[:user_id].present?
    #filter by expertise
    @ads = filter_join(:expertises) if params[:expertises].present?
    #filter by agrement
    @ads = filter_join(:agrements) if params[:agrements].present?
    #get all if no filters
    @ads = Ad.all if @ads == nil
    #limit, offset
    @ads = @ads.offset(params[:offset]).limit(params[:limit])
    render json: {ads: @ads}
  end

  # GET /ads/info/:id
  def show
    render json: @ad
  end

  # POST /ads/create
  def create
    @ad = Ad.new(ad_params)
    @ad.user_id = @user.id

    if @ad.save
      #copy parameters from user
      if @user.company != nil
        @ad.c_type_id = @user.company.c_type.id
        @ad.sub_category_id = @user.company.sub_category.id
        @ad.address = @user.company.address
        ExpertiseController.set_ad_expertises(@ad, @user.company.expertises)
        AgrementController.set_ad_agrements(@ad, @user.company.agrements)
        @ad.save
      end
      render json: @ad, status: :created
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ads/update/:id
  def update
    if @ad.update(ad_params)
      render json: @ad
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ads/delete/:id
  def destroy
    @ad.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def authorize(access)
      @user = AuthorizeController.authorize(request)
      if @user == nil or not @user.has_access?(access)
        render status: :unauthorized
      end
    end

    def authorize_self(access)
      @user = Ad.find(params[:id]).user
      if not AuthorizeController.authorize_self(request, access, @user)
        render status: :unauthorized
      end
    end

    def authorize_create
      authorize(:can_create_ads)
    end

    def authorize_index
      authorize(:can_view_ads)
    end

    def authorize_show
      authorize_self(:can_view_ads)
    end

    def authorize_update
     authorize_self(:can_update_ads)
   end

   def authorize_delete
     authorize_self(:can_delete_ads)
   end

    def set_ad
      @ad = Ad.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ad_params
      params.require(:ad).permit(:title, :description, :c_type, :sub_category)
    end
end
