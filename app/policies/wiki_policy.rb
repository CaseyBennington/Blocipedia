class WikiPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    user.admin? || user
  end

  def new?
    create?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || record.user == user
  end
end
