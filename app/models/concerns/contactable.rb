# Providers and clients have the same name and email rules, so they live here once.
module Contactable
  extend ActiveSupport::Concern

  included do
    normalizes :email, with: ->(email) { email.strip.downcase }

    validates :name, presence: true
    validates :email, presence: true,
                      format: { with: URI::MailTo::EMAIL_REGEXP },
                      uniqueness: true
  end
end
