require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  setup do
    @store = stores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stores" do
    assert_difference('Store.count') do
      post :create, stores: { domain: @store.domain, name: @store.name, owner_id: @store.owner_id }
    end

    assert_redirected_to store_path(assigns(:stores))
  end

  test "should show stores" do
    get :show, id: @store
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @store
    assert_response :success
  end

  test "should update stores" do
    put :update, id: @store, stores: { domain: @store.domain, name: @store.name, owner_id: @store.owner_id }
    assert_redirected_to store_path(assigns(:stores))
  end

  test "should destroy stores" do
    assert_difference('Store.count', -1) do
      delete :destroy, id: @store
    end

    assert_redirected_to stores_path
  end
end
