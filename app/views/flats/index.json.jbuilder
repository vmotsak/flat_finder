json.array!(@flats) do |flat|
  json.extract! flat, :id, :address, :coordinates, :desc
  json.url flat_url(flat, format: :json)
end
