require "test_helper"

# The four queries the pre-work asks for.
class QueriesTest < ActiveSupport::TestCase
  test "all clients for a given provider" do
    # Sort both sides, since we only care who's in the list, not the order.
    assert_equal [clients(:thor), clients(:steve)].sort, providers(:strange).clients.sort
  end

  test "all providers for a given client" do
    assert_equal [providers(:strange), providers(:banner)].sort, clients(:thor).providers.sort
  end

  test "all journal entries for a given client, sorted by date" do
    # Order matters here, so no sorting.
    assert_equal [journal_entries(:thor_new), journal_entries(:thor_old)],
                 clients(:thor).journal_entries.newest_first.to_a
  end

  test "all journal entries across a provider's clients, sorted by date" do
    assert_equal [journal_entries(:thor_new), journal_entries(:steve_mid), journal_entries(:thor_old)],
                 providers(:strange).journal_entries.newest_first.to_a
  end

  test "a provider's feed leaves out clients who aren't theirs" do
    assert_not_includes providers(:strange).journal_entries, journal_entries(:peter_today)
  end
end
