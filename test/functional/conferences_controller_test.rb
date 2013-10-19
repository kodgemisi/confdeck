require 'test_helper'

class ConferencesControllerTest < ActionController::TestCase
  setup do
    @conference = conferences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conferences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conference" do
    assert_difference('Conference.count') do
      post :create, conference: { address_id: @conference.address_id, description: @conference.description, email: @conference.email, facebook: @conference.facebook, name: @conference.name, phone: @conference.phone, summary: @conference.summary, twitter: @conference.twitter, website: @conference.website }
    end

    assert_redirected_to conference_path(assigns(:conference))
  end

  test "should show conference" do
    get :show, id: @conference
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conference
    assert_response :success
  end

  test "should update conference" do
    put :update, id: @conference, conference: { address_id: @conference.address_id, description: @conference.description, email: @conference.email, facebook: @conference.facebook, name: @conference.name, phone: @conference.phone, summary: @conference.summary, twitter: @conference.twitter, website: @conference.website }
    assert_redirected_to conference_path(assigns(:conference))
  end

  test "should destroy conference" do
    assert_difference('Conference.count', -1) do
      delete :destroy, id: @conference
    end

    assert_redirected_to conferences_path
  end
end
