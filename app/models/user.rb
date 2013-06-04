require 'rubygems'
require 'composite_primary_keys'

class User < EjudgeDb
  attr_accessible :user_id, :conest_id, :user_name
  belongs_to :login,:foreign_key=>'user_id'
  self.primary_keys= [:user_id,:contest_id]
  # add_index :id, ["user_id", "contest_id"], :unique => true
end
