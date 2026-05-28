class PetPolicy < ApplicationPolicy
  def index?
    user.admin? || user.vet? || user.owner?
  end

  def show?
    user.admin? || user.vet? || own_pet?
  end

  def create?
    user.admin? || own_pet?
  end

  def update?
    user.admin? || own_pet?
  end

  def destroy?
    user.admin? || own_pet?
  end

  def permitted_attributes
    attrs = [:name, :species, :breed, :date_of_birth, :weight, :photo]
    attrs << :owner_id if user.admin?
    attrs
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.admin? || user.vet?
      return scope.joins(:owner).where(owners: { user_id: user.id }) if user.owner?

      scope.none
    end
  end

  private

  def own_pet?
    user.owner? && record.owner&.user_id == user.id
  end
end
