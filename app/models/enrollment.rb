# A client signed up with a provider, and the plan they're on with that provider.
class Enrollment < ApplicationRecord
  belongs_to :provider
  belongs_to :client

  # plan can only be basic or premium, and you get helpers like premium? and basic!.
  # validate: true makes a bad plan a validation error instead of an exception.
  enum :plan, { basic: "basic", premium: "premium" }, validate: true

  # The same client can't sign up with the same provider twice. The unique index in
  # the migration backs this up.
  validates :client_id, uniqueness: { scope: :provider_id }
end
