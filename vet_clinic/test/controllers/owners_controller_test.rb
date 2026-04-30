require "test_helper"

class OwnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = owners(:one) # Usa el fixture 'one'
  end

  test "should get index" do
    get owners_url
    assert_response :success
  end

  test "should get new" do
    get new_owner_url
    assert_response :success
  end

  test "should create owner" do
    assert_difference("Owner.count") do
      post owners_url, params: { owner: { first_name: "Test", last_name: "User", email: "test@user.com", phone: "00000" } }
    end
    assert_redirected_to owner_url(Owner.last)
    assert_equal "Owner was successfully created.", flash[:notice]
  end

  test "should show owner" do
    get owner_url(@owner)
    assert_response :success
  end

  test "should get edit" do
    get edit_owner_url(@owner)
    assert_response :success
  end

  test "should update owner" do
    patch owner_url(@owner), params: { owner: { first_name: "Updated" } }
    assert_redirected_to owner_url(@owner)
    @owner.reload
    assert_equal "Updated", @owner.first_name
  end

  test "should destroy owner" do
    assert_difference("Owner.count", -1) do
      delete owner_url(@owner)
    end
    assert_redirected_to owners_url
  end

  # Test de "Camino triste" (Datos inválidos)
  test "should not create owner with invalid params" do
    post owners_url, params: { owner: { first_name: "" } } # Nombre vacío falla validación
    assert_response :unprocessable_entity
  end
end