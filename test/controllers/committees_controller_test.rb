require "test_helper"

class CommitteesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get committees_index_url
    assert_response :success
  end
end
