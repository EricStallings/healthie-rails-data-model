# Runs the four queries against the seed data and prints the SQL for each one.
# Run it with: bin/rails db:seed && bin/rails runner script/queries.rb

strange = Provider.find_by!(email: "strange@example.com")
thor = Client.find_by!(email: "thor@example.com")

{
  "All clients for #{strange.name}" => strange.clients,
  "All providers for #{thor.name}" => thor.providers,
  "#{thor.name}'s journal entries, newest first" => thor.journal_entries.newest_first,
  "Journal entries across #{strange.name}'s clients, newest first" =>
    strange.journal_entries.includes(:client).newest_first
}.each do |label, relation|
  puts "\n== #{label}"
  puts relation.to_sql
  relation.each do |record|
    puts case record
         when JournalEntry then "  #{record.created_at.to_date}  #{record.client.name}: #{record.body}"
         else "  #{record.name} <#{record.email}>"
         end
  end
end
