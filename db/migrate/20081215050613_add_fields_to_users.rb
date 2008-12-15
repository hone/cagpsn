class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :time_zone
      t.string :psn
      t.string :avatar_url
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :time_zone
      t.remove :psn
      t.remove :avatar_url
    end
  end
end
