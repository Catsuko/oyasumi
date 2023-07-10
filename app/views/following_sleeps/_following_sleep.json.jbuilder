json.extract! sleep, :id, :started_at, :ended_at
json.duration sleep.duration&.to_i
json.user do
  json.id sleep.user_id
  json.name sleep.user.name
end
