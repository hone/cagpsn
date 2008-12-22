class AddFields2ToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :headset
      t.boolean :keyboard
      t.boolean :usb_camera
      t.string  :play_style
    end
  end

  def self.down
    change_table :users do |t|
      t.remove  :headset
      t.remove  :keyboard
      t.remove  :usb_camera
      t.remove  :play_style
    end
  end
end
