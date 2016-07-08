class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save { self.role ||= :standard }
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :lockable, :timeoutable, :trackable, :validatable
  has_many :wikis
  has_many :collaborators

  enum role: [:standard, :premium, :admin]

  scope :public_wikis, -> { where('(wikis.private IS NULL OR wikis.private = ?)', false) }
  scope :private_wikis, -> { where('(wikis.private = ? AND wikis.user_id = ?)', true, @user.id) }

  def subscribed?
    stripe_charges_id?
  end

  def avatar_url(size)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end
end
