class CreateUiMessages < ActiveRecord::Migration
  def change
    create_table :ui_messages do |t|
      t.text :message_body

      t.timestamps
    end
  end
end
