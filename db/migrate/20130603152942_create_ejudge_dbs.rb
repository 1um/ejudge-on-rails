class CreateEjudgeDbs < ActiveRecord::Migration
  def change
    create_table :ejudge_dbs do |t|

      t.timestamps
    end
  end
end
