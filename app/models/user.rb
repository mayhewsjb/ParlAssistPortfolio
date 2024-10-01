class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :updates
  has_many :bugs, dependent: :destroy

  enum role: { user: 0, permitted: 1, admin: 2 }

  private
end
