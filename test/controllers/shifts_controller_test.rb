require "test_helper"

class ShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get submission" do
    get shifts_submission_url
    assert_response :success
  end

  test "should get new" do
    get shifts_new_url
    assert_response :success
  end
end
