class LargeFormatFinishing < ActiveRecord::Base

  has_many :finishing_options
  has_many :large_formats, :through => :finishing_options

  scope :has_none, -> { where(name: "None") }
end
