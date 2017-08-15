class NewsController < ApplicationController
  before_action :set_news, only: [:show, :update, :delete]

  before_action :authorize_create, only: [:create]
  before_action :authorize_show, only: [:index, :show]
  before_action :authorize_update, only: [:update]
  before_action :authorize_delete, only: [:delete]


   def filter_one(param)
    if @news != nil
      @news = @news.where(param)
    else
      @news = Company.where(param)
    end
  end

   def filter_two(param1, param2)
    if @news != nil
      @news = @news.where(param1, param2)
    else
      @news = Company.where(param1, param2)
    end
  end

  def filter_join(param)
    if @news != nil
      @news = @news.joins(param).where(param => {name: params[param]})
    else
      @news = Company.joins(param).where(param => {name: params[param]})
    end
  end

  # GET /news
  def index
     #filter by type
    if params[:c_type].present?
      if params[:c_type] == 'both'
        ids = CType.all.collect{|e|e.id}
        filter_one(c_type_id: ids)
      else
        @type = CType.find_by(name: params[:c_type])
        filter_one(c_type_id: @type.id)
      end
    end
    #filter by category
    if params[:sub_categories].present?
      ids = []
      for sub_cat in params[:sub_categories]
        ids.push(SubCategory.find_by(name: sub_cat))
      end
      ids = ids.collect{|e|e.id}
      filter_one(sub_category_id: ids)
    end
    #filter by author
    @news = filter_one(user_id: params[:user_id]) if params[:user_id].present?
    #filter by expertise
    @news = filter_join(:expertises) if params[:expertises].present?
    #filter by agrement
    @news = filter_join(:agrements) if params[:agrements].present?
    
    @users = @news.collect{|e| e.user.id} if @news != nil
    @news = News.where(user_id: @users) if @users != nil
    
    #get all if no filters
    @news = News.all if @news == nil
    filter_two("lower(title) LIKE ?", "%#{params[:title].downcase}%") if params[:title].present?
    filter_two("lower(description) LIKE ?", "%#{params[:description].downcase}%") if params[:description].present?
    #filter by date
    if params[:begin_date]
      date = Date.parse(params[:begin_date])
      @news = @news.where(created_at: date..(date + 10.year))
    end
    if params[:end_date]
      date = Date.parse(params[:end_date])
      @news = @news.where(created_at: (date - 10.year)..date)
    end
    @news = @news.distinct(:id)
    total = @news.count
    #limit, offset
    @news = @news.offset(params[:offset]).limit(params[:limit])
    render json: {news: @news, total_count: total}
  end

  # GET /news/1
  def show
    render json: @news
  end

  # POST /news
  def create
    @news = News.new(news_params)
    @news.user_id = @user.id
    if @news.save
      render json: @news, status: :created
    else
      render json: @news.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /news/1
  def update
    if @news.update(news_params)
      render json: @news
    else
      render json: @news.errors, status: :unprocessable_entity
    end
  end

  # DELETE /news/1
  def delete
    @news.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    def authorize(access)
      @user = AuthorizeController.authorize(request)
      if @user == nil or not @user.has_access?(access)
        render status: :unauthorized
      end
    end

    def authorize_self(access)
      @user = News.find(params[:id]).user
      if not AuthorizeController.authorize_self(request, access, @user)
        render status: :unauthorized
      end
    end

    def authorize_create
      authorize(:can_create_news)
    end

    def authorize_show
      authorize(:can_view_news)
    end

    def authorize_update
      authorize_self(:can_update_news)
    end

    def authorize_delete
      authorize_self(:can_delete_news)
    end

    # Only allow a trusted parameter "white list" through.
    def news_params
      params.require(:news).permit(:title, :description, :user_id)
    end
end
