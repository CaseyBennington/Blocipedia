class Collaborator < ActiveRecord::Base
  belongs_to :wiki
  belongs_to :user

  scope :collaborator_wikis, -> { where('(private = ? AND collaborators.user_id = ?)', true, @user.id) }
end
