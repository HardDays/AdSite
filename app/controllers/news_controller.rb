class NewsController < ApplicationController
  before_action :set_news, only: [:show, :update, :delete]

  before_action :authorize_create, only: [:create]
  before_action :authorize_show, only: [:index, :show]
  before_action :authorize_update, only: [:update]
  before_action :authorize_delete, only: [:delete]

  # GET /news
  def index
    @news = News.all

    @filters = ['title', 'description']
    @filters.each do |filter|
      @news = @news.where("#{filter} ILIKE ?", "%#{params[filter]}%") if params[filter] != nil
    end

    render json: @news.limit(params[:limit]).offset(params[:offset])
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
