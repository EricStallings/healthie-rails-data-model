# Runs the four queries against the seed data and prints the SQL for each one.
# Run it with: bin/rails db:seed && bin/rails runner script/queries.rb

dana = Provider.find_by!(email: "dana@example.com")
alex = Client.find_by!(email: "alex@example.com")

{
  "All clients for #{dana.name}" => dana.clients,
  "All providers for #{alex.name}" => alex.providers,
  "#{alex.name}'s journal entries, newest first" => alex.journal_entries.newest_first,
  "Journal entries across #{dana.name}'s clients, newest first" =>
    dana.journal_entries.includes(:client).newest_first
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
