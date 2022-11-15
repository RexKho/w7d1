class User < ApplicationRecord
    attr_reader :password 
    validates :username, presence: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: {scope: :username}
    before_validation :ensure_session_token
    validates :password, length: {mininum: 6}, allow_nil: true, presence: true 


    has_many :cats,
        foreign_key: :owner_id,
        class_name: :Cat,
        dependent: :destroy,
        inverse_of: :owner

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            return user 
        else
            return nil 
        end 
    end

    def password=(password)
        @password = password 
        self.password_digest = Bcrypt::Password.create(password)

    end

    def generate_unique_session_token
        token = SecureRandom::urlsafe_base64
        while User.exists?(session_token:token)
            token = SecureRandom::urlsafe_base64
        end
        token
    end

    
    def is_password?(password)
        bcrypt_object=BCrypt::Password.new(self.password_digest)
        bcrypt_object.is_password?(password)
    end
    
    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end
    
    private
      
    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

end
