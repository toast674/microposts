class User < ActiveRecord::Base
    before_save { self.email = self.email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    validates :location, presence: true, on: :update, length: { maximum: 20 } 
    validates :profile, presence: true, on: :update, length: { maximum: 200 }
    validates :password, presence: true, length: { minimum: 4, maximum: 16 }
    validates :password_confirmation, presence: true
end
