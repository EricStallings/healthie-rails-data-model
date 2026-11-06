# A small set of data to try the queries against. It clears everything first,
# so it's safe to run again.
JournalEntry.delete_all
Enrollment.delete_all
Client.delete_all
Provider.delete_all

strange = Provider.create!(name: "Dr. Stephen Strange", email: "strange@example.com")
banner  = Provider.create!(name: "Dr. Bruce Banner", email: "banner@example.com")

thor   = Client.create!(name: "Thor Odinson", email: "thor@example.com")
steve  = Client.create!(name: "Steve Rogers", email: "steve@example.com")
peter  = Client.create!(name: "Peter Parker", email: "peter@example.com")

Enrollment.create!(provider: strange, client: thor, plan: :premium)
Enrollment.create!(provider: banner, client: thor, plan: :basic)
Enrollment.create!(provider: strange, client: steve, plan: :basic)
Enrollment.create!(provider: banner, client: peter, plan: :premium)

[
  [thor, "Oatmeal and berries for breakfast.", 3.days.ago],
  [thor, "Skipped lunch, big dinner.", 1.day.ago],
  [steve, "Walked 20 minutes after dinner.", 2.days.ago],
  [peter, "Tried the new meal plan.", 1.hour.ago]
].each do |client, body, at|
  client.journal_entries.create!(body: body, created_at: at, updated_at: at)
end

puts "Seeded #{Provider.count} providers, #{Client.count} clients, " \
     "#{Enrollment.count} enrollments, #{JournalEntry.count} journal entries."
