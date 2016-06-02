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

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user && user.admin?
        scope.all
      elsif user && user.premium?
        scope.where('private IS NULL` OR private = ? OR (private = ? AND user_id = ?)', false, true, @user.id)
      else
        scope.where(private: false)
      end
    end
  end
end
