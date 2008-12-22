require 'test_helper'

class GameTest < ActiveSupport::TestCase

  test "should create game" do
    assert_difference 'Game.count' do
      game = create_game
      assert !game.new_record?, "#{game.errors.full_messages.to_sentence}"
    end
  end

  test "name can't be blank" do
    assert_no_difference 'Game.count' do
      game = create_game( :name => nil )
      assert game.errors.on(:name)
    end
  end

  test "abbreviation can't be blank" do
    assert_no_difference 'Game.count' do
      game = create_game( :abbreviation => nil )
      assert game.errors.on(:abbreviation)
    end
  end

  private
  def create_game(options = {})
    record = Game.new({ :name => "Resistance 2", :abbreviation => "R2", :forum_thread_link => "http://www.cheapassgamer.com/forums/showthread.php?t=167600" }.merge(options))
    record.save
    record
  end
end
