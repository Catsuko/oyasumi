json.extract! sleep, :id, :started_at, :ended_at
json.duration sleep.duration&.to_i
