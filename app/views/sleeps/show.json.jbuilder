json.data do
  json.extract! @sleep, :id
  json.started_at @sleep.started_at.to_i
  json.ended_at @sleep.ended_at&.to_i
end
