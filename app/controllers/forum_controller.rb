require 'uri'
require 'net/http'
require 'openssl'
require 'certified'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class ForumController < ApplicationController
 
#   def self.create_user
#     admin = ForumUser.create!(
#         display_name: 'Admin1111',
#         email: "admin1111@forum.com",
#         password: "123456"
#     )
#     puts json: admin.errors
#   end
    def self.create_user(name, email, password)
        uri = URI("https://patrimoine-forum-th.herokuapp.com/users")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(uri.path)
        params = {
        'user[display_name]' => name,
        'user[email]' => email,
        'user[password]' => password,
        'user[password_confirmation]' => password
        }
        request.body = URI.encode_www_form(params)

        request["Content-Type"] = 'application/x-www-form-urlencoded'

        response = https.request(request)
        puts 'AAAAAAAAAAAAAAAAAAAAAAA'
        puts name, email, password
        puts json: response.body
    end
end