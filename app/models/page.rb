class Page < ActiveRecord::Base
  has_many :page_contents, :dependent => :destroy

  
  scope :home, -> { where(title: "Home Page") }
  scope :about, -> { where(title: "About Page") }

  accepts_nested_attributes_for :page_contents, :allow_destroy => true
end
