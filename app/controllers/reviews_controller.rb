class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :update, :delete]
  
  before_action :authorize, only: [:create, :update, :delete]

  # GET /reviews
  def index
    @reviews = Review.all

    render json: @reviews
  end

  # GET /reviews/1
  def show
    render json: @review
  end

  # POST /reviews
  def create
    @review = Review.new(review_params)
    @review.user_id = @user.id
    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  def delete
    @review.destroy
  end

  private

    def authorize
      @user = AuthorizeController.authorize(request)
      puts json: @user.accesses
      if @user == nil or not @user.has_access?(:can_crud_reviews)
        render status: :forbidden
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def review_params
      params.require(:review).permit(:title, :body, :author, :user_id)
    end
end
