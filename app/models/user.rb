class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def as_json(options = {})
    h = super(options.merge({ except: [:created_at, :updated_at] }))
    h
  end

  has_many :orders
end
