require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appointment = appointments(:one)
    @pet = pets(:one)
    @vet = vets(:one)
  end

  test "should get index" do
    get appointments_url
    assert_response :success
  end

  test "should create appointment" do
    assert_difference("Appointment.count") do
      post appointments_url, params: { appointment: { date: DateTime.now + 1.day, reason: "Checkup", status: "scheduled", pet_id: @pet.id, vet_id: @vet.id } }
    end
    assert_redirected_to appointment_url(Appointment.last)
  end

  test "should destroy appointment" do
    assert_difference("Appointment.count", -1) do
      delete appointment_url(@appointment)
    end
    assert_redirected_to appointments_url
  end
end 