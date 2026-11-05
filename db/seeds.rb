# A small set of data to try the queries against. It clears everything first,
# so it's safe to run again.
JournalEntry.delete_all
Enrollment.delete_all
Client.delete_all
Provider.delete_all

dana = Provider.create!(name: "Dana Ortiz", email: "dana@example.com")
sam  = Provider.create!(name: "Sam Lee", email: "sam@example.com")

alex   = Client.create!(name: "Alex Kim", email: "alex@example.com")
jordan = Client.create!(name: "Jordan Patel", email: "jordan@example.com")
riley  = Client.create!(name: "Riley Chen", email: "riley@example.com")

Enrollment.create!(provider: dana, client: alex, plan: :premium)
Enrollment.create!(provider: sam, client: alex, plan: :basic)
Enrollment.create!(provider: dana, client: jordan, plan: :basic)
Enrollment.create!(provider: sam, client: riley, plan: :premium)

[
  [alex, "Oatmeal and berries for breakfast.", 3.days.ago],
  [alex, "Skipped lunch, big dinner.", 1.day.ago],
  [jordan, "Walked 20 minutes after dinner.", 2.days.ago],
  [riley, "Tried the new meal plan.", 1.hour.ago]
].each do |client, body, at|
  client.journal_entries.create!(body: body, created_at: at, updated_at: at)
end

puts "Seeded #{Provider.count} providers, #{Client.count} clients, " \
     "#{Enrollment.count} enrollments, #{JournalEntry.count} journal entries."
