class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # has_secure_password
  has_one :profile, dependent: :destroy
  before_save { self.email = email.downcase }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :send_otp
  validates :phone_number, uniqueness: true, allow_nil: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  has_many :pictures, as: :imageable   
  accepts_nested_attributes_for :pictures
            
  def send_otp
    self.verify_otp = rand.to_s[2..7]
  end

  def self.added_temp_email(user,params)
    user.email = Faker::Internet.email rescue nil
  end

end
