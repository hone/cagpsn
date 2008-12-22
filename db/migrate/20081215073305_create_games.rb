class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :name
      t.string :abbreviation
      t.string :forum_thread_link
      t.string :game_night_thread_link
      t.string :clan_thread_link
      t.string :online_leaderboards_link
      t.string :official_game_link

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
