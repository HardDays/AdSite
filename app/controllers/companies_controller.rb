class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]

  # GET /companies
  def index
    @companies = Company.all

    if params[:c_type].present?
      @type = CType.find_by(name: params[:c_type])
      @companies = @companies.where(c_type_id: @type.id)
    end

    if params[:sub_category].present?
      @type = SubCategory.find_by(name: params[:sub_category])
      @companies = @companies.where(sub_category_id: @type.id)
    end

    @filters = ['name', 'address', 'other_address', 'email', 'opening_times', 'description']
    @filters.each do |filter|
      @companies = @companies.where("#{filter} ILIKE ?", "%#{params[filter]}%") if params[filter] != nil
    end

    render json: @companies
  end

  # GET /companies/1
  def show
    render json: @company
  end

  def self.add_company
    @company = Company.new(company_params)

    if @company.save
      render json: @company, status: :created, location: @company
      return true
    else
      render json: @company.errors, status: :unprocessable_entity
      return false
    end
  end

  # POST /companies
  def create
    @company = Company.new(company_params)

    if @company.save
      render json: @company, status: :created, location: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:name, :logo, :address, :other_address, :email, :phone, :opening_times, :type, :company_id, :description, :links, :user_id)
    end
end
