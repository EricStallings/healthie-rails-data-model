class Client < ApplicationRecord
  include Contactable

  # Deleting a client deletes their enrollments and journal entries too.
  has_many :enrollments, dependent: :destroy
  has_many :providers, through: :enrollments
  has_many :journal_entries, dependent: :destroy
end
