class WikiPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    #(user.admin? || user) if user
    user.present?
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
    (user.admin? || (record.user == user)) if user
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.try(:admin?) # user && user.admin?
        scope.all
      elsif user.try(:premium?) # user && user.premium?
        result_set = ActiveRecord::Base.connection.execute("
        SELECT id, title, body, private, wikis.user_id
        FROM wikis
        WHERE (wikis.private IS NULL OR wikis.private = 'f') OR (wikis.private = 't' AND wikis.user_id = '#{@user.id}')

        UNION

        SELECT wikis.id, title, body, private, wikis.user_id
        FROM wikis
        INNER JOIN collaborators ON collaborators.wiki_id = wikis.id
        WHERE (wikis.private = 't' AND collaborators.user_id = '#{@user.id}')
        ")
        scope.where(result_set.to_sql)
        # public_wikis
        # private_wikis
        # collaborator_wikis
        # scope.where((public_wikis) OR (private_wikis) OR (collaborator_wikis))
        # scope.joins('LEFT OUTER JOIN collaborators ON collaborators.wiki_id = wikis.id').where('(wikis.private IS NULL OR wikis.private = ? OR (wikis.private = ? AND wikis.user_id = ?)) OR (wikis.private = ? AND collaborators.user_id = ?)', false, true, @user.id, true, @user.id)
        # scope.joins(:collaborators).where('(wikis.private IS NULL OR wikis.private = ? OR (wikis.private = ? AND wikis.user_id = ?)) OR (wikis.private = ? AND collaborators.user_id = ?)', false, true, @user.id, true, @user.id)
        # scope.where('private IS NULL OR private = ? OR (private = ? AND user_id = ?) OR (private = ? AND collaborators = ?)', false, true, @user.id, true, @user.id)
      elsif user.try(:standard?)
        scope.where('private IS NULL or private = ?', false).union.joins(:collaborators).where('(private = ? AND collaborators.user_id = ?)', true, @user.id)
        # scope.joins('LEFT OUTER JOIN collaborators ON collaborators.wiki_id = wikis.id').where('wikis.private is NULL OR wikis.private = ? OR (private = ? AND collaborators.user_id = ?)', false, true, @user.id)
        # scope.joins(:collaborators).where('wikis.private is NULL OR wikis.private = ?', false)
        # scope.joins(:collaborators).where('private is NULL OR private = ? OR (private = ? AND collaborators.user_id = ?)', false, true, @user.id)
      else
        scope.where(private: false)
      end
    end
  end
end
