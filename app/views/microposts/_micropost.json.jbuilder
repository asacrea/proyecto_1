json.extract! micropost, :id, :name, :ext, :size, :user_id, :created_at, :updated_at
json.url micropost_url(micropost, format: :json)
