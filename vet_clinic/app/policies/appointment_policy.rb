class AppointmentPolicy < ApplicationPolicy
  def index?
    user.admin? || user.vet? || user.owner?
  end

  def show?
    user.admin? || assigned_vet? || own_appointment?
  end

  def create?
    user.admin? || assigned_vet? || own_appointment?
  end

  def new?
    user.admin? || user.vet? || user.owner?
  end

  def update?
    user.admin? || assigned_vet? || own_appointment?
  end

  def destroy?
    user.admin? || assigned_vet? || own_appointment?
  end

  def permitted_attributes
    attrs = [:date, :reason, :status]
    attrs += [:pet_id, :vet_id] if user.admin?
    attrs << :pet_id if user.vet?
    attrs << :vet_id if user.owner?
    attrs
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.admin?
      return scope.joins(:vet).where(vets: { user_id: user.id }) if user.vet?
      return scope.joins(pet: :owner).where(owners: { user_id: user.id }) if user.owner?

      scope.none
    end
  end

  private

  def assigned_vet?
    user.vet? && record.vet&.user_id == user.id
  end

  def own_appointment?
    user.owner? && record.pet&.owner&.user_id == user.id
  end
end
