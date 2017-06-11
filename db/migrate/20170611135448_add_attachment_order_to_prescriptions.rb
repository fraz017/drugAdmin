class AddAttachmentOrderToPrescriptions < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.attachment :prescription
    end
  end

  def self.down
    remove_attachment :orders, :prescription
  end
end
