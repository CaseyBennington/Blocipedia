class ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def index?
  end

  def show?
    scope.where(id: wiki.id).exists?
  end

  def create?
  end

  def new?
    create?
  end

  def update?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || current_user == user
  end

  def scope
    Pundit.policy_scope!(user, wiki.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(private: false)
      end
    end
  end
end
