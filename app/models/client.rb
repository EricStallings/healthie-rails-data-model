class Client < ApplicationRecord
  include Contactable

  has_many :enrollments, dependent: :destroy
  has_many :providers, through: :enrollments
  has_many :journal_entries, dependent: :destroy
end
