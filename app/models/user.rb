class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save { self.role ||= :standard }
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :lockable, :timeoutable, :trackable, :validatable
  has_many :wikis

  enum role: [:standard, :premium, :admin]
end
