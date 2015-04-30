class Post < ActiveRecord::Base

 # mount_uploader :featured_image_file_name, PostImageUploader
 validates_presence_of :featured_image_file_name
end
