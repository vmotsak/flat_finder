class FlatsSearch
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::AttributeMethods

  attr_accessor :from, :rooms, :images, :lvl

  def initialize(h)
    h.each { |k, v| send("#{k}=", v) } if h
  end
end