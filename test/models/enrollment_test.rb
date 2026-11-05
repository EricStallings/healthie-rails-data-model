require "test_helper"

class EnrollmentTest < ActiveSupport::TestCase
  test "a client can be on a different plan with each provider" do
    assert enrollments(:dana_alex).premium?
    assert enrollments(:sam_alex).basic?
  end

  test "plan has to be basic or premium" do
    enrollment = Enrollment.new(provider: providers(:dana), client: clients(:riley), plan: "gold")
    assert_not enrollment.valid?
    assert_includes enrollment.errors[:plan], "is not included in the list"
  end

  test "a client can only enroll with the same provider once" do
    duplicate = Enrollment.new(provider: providers(:dana), client: clients(:alex))
    assert_not duplicate.valid?
  end

  test "the database backs up the unique pair even if validations are skipped" do
    assert_raises(ActiveRecord::RecordNotUnique) do
      Enrollment.new(provider: providers(:dana), client: clients(:alex)).save(validate: false)
    end
  end
end
