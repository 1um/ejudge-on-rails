class EjudgeDb < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "ejudge_database"
end
