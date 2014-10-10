namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    AdminUser.create!(email: "stevenag006@hotmail.com",
                    password: "qwerty007",
                    password_confirmation: "qwerty007")
  end
end
