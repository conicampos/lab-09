class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  def index
    @appointments = policy_scope(Appointment).includes(:pet, :vet)
  end

  def show
    # B.3: Eager load para evitar N+1 en las notas enriquecidas
    @appointment = Appointment.includes(treatments: :rich_text_clinical_notes).find(params[:id])
    authorize @appointment
  end

  def new
    @appointment = Appointment.new
    authorize @appointment
  end

  def edit
    authorize @appointment
  end

  def create
    @appointment = Appointment.new
    @appointment.assign_attributes(appointment_params)
    apply_role_appointment_links(@appointment)
    authorize @appointment
    if @appointment.save
      redirect_to @appointment, notice: 'Appointment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    apply_role_appointment_links(@appointment)
    authorize @appointment
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: 'Appointment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @appointment
    @appointment.destroy
    redirect_to appointments_url, notice: 'Appointment was successfully destroyed.', status: :see_other
  end

  private
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(policy(@appointment).permitted_attributes)
    end

    def apply_role_appointment_links(appointment)
      if current_user.vet? && appointment.new_record?
        appointment.vet = current_user.vet
      elsif current_user.owner? && appointment.new_record?
        appointment.pet = current_user.owner.pets.find_by(id: params.dig(:appointment, :pet_id))
      end
    end
end
