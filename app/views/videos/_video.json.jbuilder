json.extract! video, :id, :title, :url, :thumbnail, :posted_date, :description, :play_count, :channel_id, :channel_name, :channel_url, :created_at, :updated_at
json.url video_url(video, format: :json)
