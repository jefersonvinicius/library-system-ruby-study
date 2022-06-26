require "test_helper"

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get authors_create_url
    assert_response :success
  end
end
