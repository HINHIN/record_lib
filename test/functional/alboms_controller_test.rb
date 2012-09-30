require 'test_helper'

class AlbomsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

end
