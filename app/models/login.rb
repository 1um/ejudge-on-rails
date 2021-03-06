class Login < EjudgeDb
  bad_attribute_names :readonly
  validates_presence_of :readonly
  attr_accessible :user_id, :login, :email, :password
  set_primary_key :user_id
  has_many :users, :foreign_key=>'user_id'

  def names
    users.map(&:username).uniq.inject(""){|s,name|s+=name+','}[0..-2]
  end

  def self.search(search)
    if search
      where('login LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  def update_attributes( attributes )
    names = attributes.slice(:names)
    attributes.except!(:names)
    if super(attributes)&&names
      users.each{|u| u.update_attribute(:username,names[:names])}
    end

  end
end
