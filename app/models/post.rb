class Post < ActiveRecord::Base

  has_attached_file :featured_image, :default_url => "no-image.png"
  validates_attachment :featured_image, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] } 

end
