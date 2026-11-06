# Healthie pairing: Rails data model

Providers (e.g. dietitians), their clients, and the clients' journal entries.

## Running it

Needs Ruby 4.0.6 (see `.ruby-version`) and SQLite.

```bash
bundle install
bin/rails db:setup                  # create the db, load the schema, seed it
bin/rails runner script/queries.rb  # run the four queries and print their SQL
bin/rails test                      # model tests
bin/rails console                   # poke around
```

## Schema

```
providers                 enrollments                  clients
---------                 -----------                  -------
id                   ┌──< provider_id                  id
name                 │    client_id  >───────────────┐ name
email (unique)  ─────┘    plan ('basic'|'premium')   └─ email (unique)
                          unique (provider_id, client_id)
                                                         │
                                       journal_entries   │
                                       ---------------   │
                                       client_id  >──────┘
                                       body (text)
                                       created_at
                                       index (client_id, created_at)
```

- **`Enrollment` is the join model and holds the plan.** The plan describes the
  relationship, not either side: a client can be premium with one provider and
  basic with another. The unique index on `(provider_id, client_id)` keeps it to
  one plan per pair.
- **`plan` is a string-backed enum** (`basic` / `premium`), so the raw rows are
  readable. A check constraint backs up the model validation.
- **Providers and clients are separate tables** that share name and email rules
  through the `Contactable` concern. Emails are normalized (stripped and
  downcased) and unique within each table.
- **Journal entries belong to a client only**, not to a provider. A provider
  sees an entry because the client is enrolled with them.

## The queries

```ruby
provider.clients                            # all clients for a provider
client.providers                            # all providers for a client
client.journal_entries.newest_first         # a client's entries, by date
provider.journal_entries.newest_first       # entries across a provider's clients
```

`newest_first` orders by `created_at DESC, id DESC`. The `id` breaks ties so the
order is stable. `script/queries.rb` prints the SQL for each query.

## Tradeoffs and what I'd revisit

- **Sorting by `created_at`.** If clients can backfill entries ("what I ate
  yesterday"), I'd add an `entry_date` and sort on that.
- **Separate tables vs. one `users` table.** If one person could be both a
  provider and a client, or if both need to log in, I'd move to a shared table.
- **"Dr." lives in the name.** That's fine for seed data, but not every provider
  is a doctor (most dietitians aren't), so I'd add a `title` or `credentials`
  column and keep `name` plain for sorting and search.
- **Large datasets.** The provider feed joins through `clients` and could join
  `enrollments` directly. At scale I'd also paginate by keyset rather than
  offset, and look at denormalizing the feed if it gets hot.
- **Cascade deletes** are done in Rails (`dependent: :destroy`). For big
  accounts I'd move them to the database or a background job.
