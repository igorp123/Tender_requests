require 'test_helper'

class RequestDrugsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @request_drug = request_drugs(:one)
  end

  test "should get index" do
    get request_drugs_url
    assert_response :success
  end

  test "should get new" do
    get new_request_drug_url
    assert_response :success
  end

  test "should create request_drug" do
    assert_difference('RequestDrug.count') do
      post request_drugs_url, params: { request_drug: {  } }
    end

    assert_redirected_to request_drug_url(RequestDrug.last)
  end

  test "should show request_drug" do
    get request_drug_url(@request_drug)
    assert_response :success
  end

  test "should get edit" do
    get edit_request_drug_url(@request_drug)
    assert_response :success
  end

  test "should update request_drug" do
    patch request_drug_url(@request_drug), params: { request_drug: {  } }
    assert_redirected_to request_drug_url(@request_drug)
  end

  test "should destroy request_drug" do
    assert_difference('RequestDrug.count', -1) do
      delete request_drug_url(@request_drug)
    end

    assert_redirected_to request_drugs_url
  end
end
