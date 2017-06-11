class AddAttachmentOrderToPhotos < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :orders, :photo
  end
end
