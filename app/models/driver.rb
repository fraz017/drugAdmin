class Driver < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  def as_json(options = {})
    h = super(options.merge({ except: [:created_at, :updated_at] }))
    h
  end

  has_many :orders, dependent: :destroy
  has_many :items, dependent: :destroy
  validates_associated :items
  accepts_nested_attributes_for :items, allow_destroy: true
end
