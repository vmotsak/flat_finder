class Flat
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Geocoder::Model::Mongoid

  geocoded_by :address
  after_validation :geocode, :if => lambda { |obj| obj.address_changed? }

  field :coordinates, type: Array
  field :address, type: String
  field :desc, type: String

  def self.filter flats_search
    criteria = self.all
    criteria = criteria.where(:images.not => {"$size"=>0}) if flats_search.images
    criteria = criteria.where(:lvl.gt => flats_search.lvl) if flats_search.lvl
    criteria
  end

  def move
    radius = 200
    # Convert radius from meters to degrees
    radius_in_degrees = radius / 111000.0

    u = rand
    v = rand
    w = radius_in_degrees * Math.sqrt(u)
    t = 2 * Math::PI * v
    x = w * Math.cos(t)
    y = w * Math.sin(t)
    y0 = coordinates[0]
    # Adjust the x-coordinate for the shrinking of the east-west distances
    new_x = x / Math.cos(y0)
    x0 = coordinates[1]
    new_lon = new_x + x0
    new_lat = y + y0
    self.coordinates=[new_lat, x0]
  end
end
