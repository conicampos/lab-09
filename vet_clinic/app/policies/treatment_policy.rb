class TreatmentPolicy < ApplicationPolicy
  def create?
    user.admin? || assigned_vet?
  end

  def update?
    user.admin? || assigned_vet?
  end

  def destroy?
    user.admin? || assigned_vet?
  end

  def permitted_attributes
    attrs = [:name, :medication, :dosage, :clinical_notes, :administered_at]
    attrs << :appointment_id if user.admin?
    attrs
  end

  private

  def assigned_vet?
    user.vet? && record.appointment&.vet&.user_id == user.id
  end
end
