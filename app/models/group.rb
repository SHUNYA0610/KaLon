class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, source: :user
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id', dependent: :destroy
  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

  validates :name, presence: true
  validates :introduction, presence: true
  
  has_one_attached :group_image
  
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

end
