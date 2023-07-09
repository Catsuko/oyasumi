json.data do
  json.array! @sleeps, partial: 'following_sleeps/following_sleep', as: :sleep
end
