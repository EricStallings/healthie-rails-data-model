class CreateJournalEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :journal_entries do |t|
      # No index of its own, the one below covers client_id lookups too.
      t.references :client, null: false, foreign_key: true, index: false
      t.text :body, null: false
      t.timestamps
    end

    # Lets "a client's entries, newest first" read straight off the index.
    add_index :journal_entries, %i[client_id created_at]
  end
end
