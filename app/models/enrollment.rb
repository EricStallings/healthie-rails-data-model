# A client signed up with a provider, and the plan they're on with that provider.
class Enrollment < ApplicationRecord
  belongs_to :provider
  belongs_to :client

  enum :plan, { basic: "basic", premium: "premium" }, validate: true

  validates :client_id, uniqueness: { scope: :provider_id }
end
