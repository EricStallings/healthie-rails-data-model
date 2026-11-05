class JournalEntry < ApplicationRecord
  belongs_to :client

  validates :body, presence: true

  # id breaks ties on created_at, so the order doesn't shift between runs.
  scope :newest_first, -> { order(created_at: :desc, id: :desc) }
end
