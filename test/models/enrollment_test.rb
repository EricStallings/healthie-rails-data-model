require "test_helper"

class EnrollmentTest < ActiveSupport::TestCase
  test "a client can be on a different plan with each provider" do
    assert enrollments(:strange_thor).premium?
    assert enrollments(:banner_thor).basic?
  end

  test "plan has to be basic or premium" do
    enrollment = Enrollment.new(provider: providers(:strange), client: clients(:peter), plan: "gold")
    assert_not enrollment.valid?
    assert_includes enrollment.errors[:plan], "is not included in the list"
  end

  test "a client can only enroll with the same provider once" do
    duplicate = Enrollment.new(provider: providers(:strange), client: clients(:thor))
    assert_not duplicate.valid?
  end

  test "the database backs up the unique pair even if validations are skipped" do
    assert_raises(ActiveRecord::RecordNotUnique) do
      Enrollment.new(provider: providers(:strange), client: clients(:thor)).save(validate: false)
    end
  end
end
