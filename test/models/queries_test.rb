require "test_helper"

# The four queries the pre-work asks for.
class QueriesTest < ActiveSupport::TestCase
  test "all clients for a given provider" do
    assert_equal [clients(:alex), clients(:jordan)].sort, providers(:dana).clients.sort
  end

  test "all providers for a given client" do
    assert_equal [providers(:dana), providers(:sam)].sort, clients(:alex).providers.sort
  end

  test "all journal entries for a given client, sorted by date" do
    assert_equal [journal_entries(:alex_new), journal_entries(:alex_old)],
                 clients(:alex).journal_entries.newest_first.to_a
  end

  test "all journal entries across a provider's clients, sorted by date" do
    assert_equal [journal_entries(:alex_new), journal_entries(:jordan_mid), journal_entries(:alex_old)],
                 providers(:dana).journal_entries.newest_first.to_a
  end

  test "a provider's feed leaves out clients who aren't theirs" do
    assert_not_includes providers(:dana).journal_entries, journal_entries(:riley_today)
  end
end
