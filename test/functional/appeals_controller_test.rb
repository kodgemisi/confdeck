require 'test_helper'

class AppealsControllerTest < ActionController::TestCase
  setup do
    @appeal = appeals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:appeals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create appeal" do
    assert_difference('Appeal.count') do
      post :create, appeal: { conference_id: @appeal.conference_id, topic_id: @appeal.topic_id }
    end

    assert_redirected_to appeal_path(assigns(:appeal))
  end

  test "should show appeal" do
    get :show, id: @appeal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @appeal
    assert_response :success
  end

  test "should update appeal" do
    put :update, id: @appeal, appeal: { conference_id: @appeal.conference_id, topic_id: @appeal.topic_id }
    assert_redirected_to appeal_path(assigns(:appeal))
  end

  test "should destroy appeal" do
    assert_difference('Appeal.count', -1) do
      delete :destroy, id: @appeal
    end

    assert_redirected_to appeals_path
  end
end
