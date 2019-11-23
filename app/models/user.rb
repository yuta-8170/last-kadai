class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
    validates :job, presence: true, length: { maximum: 50 }
    validates :area, presence: true, length: { maximum: 50 }
    validates :age, presence: true, length: { maximum: 50 }
    validates :content, presence: true, length: { maximum: 50 }
    
    has_many :microposts
    has_secure_password
    
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    has_many :favorites
    has_many :favposts, through: :favorites, source: :micropost
    
    has_many :matchings
    
    has_many :comments
    
    has_many :messages, dependent: :destroy
    has_many :entries, dependent: :destroy
    
    has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
    has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
        
    def follow(other_user)
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end
    
    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end
    
    def following?(other_user)
        self.followings.include?(other_user)
    end
    
    def feed_microposts
        Micropost.where(user_id: self.following_ids + [self.id])
    end
    
    def like(micropost)
      favorites.find_or_create_by(micropost_id: micropost.id)
    end
  
    def unlike(micropost)
      favorite = favorites.find_by(micropost_id: micropost.id)
      favorite.destroy if favorite
    end
  
    def  favpost?(micropost)
      self.favposts.include?(micropost)
    end
    
    def matchers
      followings & followers
    end
    
    def self.search(search) #ここでのself.はUser.を意味する
      if search
        where(['content LIKE ?', "%#{search}%"]) #検索とnameの部分一致を表示。User.は省略
      else
        all #全て表示。User.は省略
      end
    end
    
    def create_notification_follow!(current_user)
      temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
      if temp.blank?
        notification = current_user.active_notifications.new(
          visited_id: id,
          action: 'follow'
        )
        notification.save if notification.valid?
      end
    end
    
    # def matching?
    # self.matchings.include?
    # end
end
