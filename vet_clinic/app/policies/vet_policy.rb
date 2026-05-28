class VetPolicy < ApplicationPolicy
  def index?
    user.admin? || user.vet? || user.owner?
  end

  def show?
    user.admin? || user.vet? || user.owner?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || (user.vet? && record.user_id == user.id)
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    [:first_name, :last_name, :email, :phone, :specialization]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.admin? || user.vet? || user.owner?

      scope.none
    end
  end
end
