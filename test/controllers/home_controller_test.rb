require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get read_csv" do
    get home_read_csv_url
    assert_response :success
  end

end
