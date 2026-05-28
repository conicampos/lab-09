class OwnerPolicy < ApplicationPolicy
  def index?
    user.admin? || user.vet? || user.owner?
  end

  def show?
    user.admin? || user.vet? || own_record?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || own_record?
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    [:first_name, :last_name, :email, :phone]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.admin? || user.vet?
      return scope.where(user_id: user.id) if user.owner?

      scope.none
    end
  end

  private

  def own_record?
    user.owner? && record.user_id == user.id
  end
end
