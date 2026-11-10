# The join between providers and clients. The plan goes here, not on either
# side, since a client can be premium with one provider and basic with another.
class CreateEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrollments do |t|
      # No index of its own, the unique index below already starts with provider_id.
      t.references :provider, null: false, foreign_key: true, index: false
      t.references :client, null: false, foreign_key: true
      t.string :plan, null: false, default: "basic"
      t.timestamps
    end

    # One enrollment per provider and client. provider_id goes first so this also
    # handles "all clients for a provider", and t.references indexed client_id.
    add_index :enrollments, %i[provider_id client_id], unique: true
    # The database itself refuses any plan that isn't basic or premium, even if the
    # model check is skipped.
    add_check_constraint :enrollments, "plan IN ('basic', 'premium')", name: "enrollments_plan_valid"
  end
end
