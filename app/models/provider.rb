class Provider < ApplicationRecord
  include Contactable

  has_many :enrollments, dependent: :destroy
  has_many :clients, through: :enrollments
  # Goes through their clients, which is what makes "all entries across a provider's
  # clients" a one-liner.
  has_many :journal_entries, through: :clients
end
