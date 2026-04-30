require "test_helper"

class VetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vet = vets(:one)
  end

  test "should get index" do
    get vets_url
    assert_response :success
  end

 test "should create vet" do
    assert_difference("Vet.count", 1) do
      post vets_url, params: { vet: { 
        first_name: "Gregory", 
        last_name: "House", 
        email: "house.new@clinic.com", # Asegúrate que sea un email nuevo
        specialization: "Diagnostics" 
      } }
    end
    assert_redirected_to vet_url(Vet.last)
  end

  test "should update vet" do
    patch vet_url(@vet), params: { vet: { last_name: "Updated" } }
    assert_redirected_to vet_url(@vet)
  end

  test "should destroy vet" do
    assert_difference("Vet.count", -1) do
      delete vet_url(@vet)
    end
    assert_redirected_to vets_url
  end
end 