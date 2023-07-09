json.extract! sleep, :id, :started_at, :ended_at
json.user do
  json.id sleep.user_id
  json.name sleep.user.name
end
