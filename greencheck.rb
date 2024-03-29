#!/usr/bin/env ruby
# encoding: UTF-8

require "rubygems"
require "json"
require "net/http"
require "uri"

# The URL to check
url = ARGV[0]

# Exit program if no URL is given
if url == nil
    puts "[!] No argument supplied"
    exit(0)
end

# Exit program when incorrect URL is given
if !(url =~ URI::regexp(%w(http https)))  
    puts "[!] Incorrect URL"
    exit(0)
end

# Define the json request file for thegreenwebfoundation.org
domain   = URI.parse(url).host
json     = "http://api.thegreenwebfoundation.org/greencheck/" + domain
uri      = URI.parse(json)
http     = Net::HTTP.new(uri.host, uri.port)
request  = Net::HTTP::Get.new(uri.request_uri)

# Set a User-Agent string
request["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/29.0"

# Get the json file from thegreenwebfoundation.org
response = http.request(request)

# Exit program when incorrect response code is received
if !response.code.to_i == 200
    puts "[!] The response code received from thegreenwebfoundation.org is not OK."
    exit(0)
end

# All checks are OK. Continue
data     = response.body
hashval  = JSON.parse(data)

# Output the result
if hashval["green"] == true
    puts "[+] " + url + " was checked and found green"
    if hashval["hostedby"] != 0
        puts "[+] This website is hosted by " + hashval["hostedby"] + " - " + hashval["hostedbywebsite"]
    end
else
    puts "[-] " + url + " was checked and found not green"
end

