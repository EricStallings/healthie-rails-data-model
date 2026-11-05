class Provider < ApplicationRecord
  include Contactable

  has_many :enrollments, dependent: :destroy
  has_many :clients, through: :enrollments
  has_many :journal_entries, through: :clients
end
