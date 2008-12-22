require File.dirname(__FILE__) + '/../test_helper'

class User
  attr_reader :crypted_password
end

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  include 
  fixtures :users

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user( {:login => nil}, false )
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  test "should require psn" do
    assert_no_difference 'User.count' do
      u = create_user(:psn => nil)
      assert u.errors.on(:psn)
    end
  end

  def test_should_not_rehash_password
    user = users(:quentin)
    user.login = 'quentin2'
    user.save!

    assert_equal user, User.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_user
    user = users(:quentin)
    assert_equal user, User.authenticate('quentin', 'monkey')
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  test "should mass assign values" do
    user = users(:quentin)
    users_params = {"avatar_url"=>"http://en.gravatar.com/userimage/454952/8c557ff3c330.jpg", "usb_camera"=>"1", "psn"=>"quasar", "name"=>"Rufus Bolan", "keyboard"=>"1", "headset"=>"1", "time_zone"=>"Eastern Time (US & Canada)", "play_style"=>"PRO NOOB", "email"=>"hone02@gmail.com"}
    user.update_attributes( users_params )

    updated_user = User.find_by_login( 'quentin' )
    assert_not_nil updated_user, "User 'quentin' does not exist."
    # check the updated values
    users_params.each do |key, value|
      field_value = updated_user.send( key )
      # special handling for booleans
      if field_value.is_a?( FalseClass ) or field_value.is_a?( TrueClass )
        corrected_value =
          if value == "1"
            true
          else
            false
          end

        assert_equal field_value, corrected_value
      else
        assert_equal field_value, value
      end
    end
  end

  test "should not mass assign values" do
    user = users(:quentin)
    user_params = { :login => "new_login", :salt => "new_salt", :crypted_password => "crypted_password" }
    user.update_attributes( user_params )

    updated_user = User.find_by_login( "quentin" )
    assert_not_nil updated_user, "User 'quentin' does not exist."
    # check that the values have not been updated
    user_params.each do |key, value|
      assert_not_equal updated_user.send( key ), value
    end
  end

protected
  def create_user(options = {}, set_login = true)
    record = User.new({ :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69', :psn => 'quire' }.merge(options))
    # can't mass assign login
    record.login = 'quire' if set_login
    record.login = options[:login] if options[:login]
    record.save
    record
  end
end
