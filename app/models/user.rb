class User < EjudgeDb
  attr_accessible :user_id, :conest_id, :user_name
  belongs_to :login,:foreign_key=>'user_id'
end
