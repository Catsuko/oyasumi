json.data do
  json.started_at @sleep.started_at.to_i
  json.ended_at @sleep.ended_at&.to_i
end
