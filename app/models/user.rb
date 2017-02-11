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
    has_many :microposts
    has_many :following_relationships, class_name: "Relationship",
                                        foreign_key: "follower_id",
                                        dependent: :destroy
    has_many :following_users, through: :following_relationships, source: :followed
    has_many :follower_relationships, class_name: "Relationship",
                                        foreign_key: "followed_id",
                                        dependent: :destroy
    has_many :follower_users, through: :follower_relationships, source: :follower
    has_many :likes, dependent: :destroy
    has_many :like_microposts, through: :likes, source: :micropost
    # 他のユーザーをフォローする
    def follow(other_user)
        following_relationships.find_or_create_by(followed_id: other_user.id)
    end
    
    # フォローしているユーザーをアンフォローする
    def unfollow(other_user)
        following_relationships = following_relationships.find_by(followed_id: other_user.id)
        following_relationships.destroy if following_relationship
    end
    
    # あるユーザーをフォローしているかどうか？
    def following?(other_user)
        following_users.include?(other_user)
    end
    
    #他の投稿をお気に入り登録する※
    def like(micropost)
        likes.find_or_create_by(micropost_id: micropost.id)
    end
  
    #お気に入りを解除する※
    def unlike(micropost)    
        like = likes.find_by(micropost_id: micropost.id)
        like.destroy if like 
    end
    
    # ある投稿をお気に入りしているかどうか？
    def like?(micropost)
        like_microposts.include?(micropost)
    end
    
    def feed_items
        Micropost.where(user_id: following_user_ids + [self.id])
    end
end
