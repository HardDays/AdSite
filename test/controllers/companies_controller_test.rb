require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:one)
  end

  test "should get index" do
    get companies_url, as: :json
    assert_response :success
  end

  test "should create company" do
    assert_difference('Company.count') do
      post companies_url, params: { company: { address: @company.address, company_id: @company.company_id, description: @company.description, email: @company.email, links: @company.links, logo: @company.logo, name: @company.name, opening_times: @company.opening_times, other_address: @company.other_address, phone: @company.phone, type: @company.type } }, as: :json
    end

    assert_response 201
  end

  test "should show company" do
    get company_url(@company), as: :json
    assert_response :success
  end

  test "should update company" do
    patch company_url(@company), params: { company: { address: @company.address, company_id: @company.company_id, description: @company.description, email: @company.email, links: @company.links, logo: @company.logo, name: @company.name, opening_times: @company.opening_times, other_address: @company.other_address, phone: @company.phone, type: @company.type } }, as: :json
    assert_response 200
  end

  test "should destroy company" do
    assert_difference('Company.count', -1) do
      delete company_url(@company), as: :json
    end

    assert_response 204
  end
end
