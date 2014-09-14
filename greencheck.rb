#!/usr/bin/env ruby
# encoding: UTF-8

require "rubygems"
require "json"
require "net/http"
require "uri"

# The URL to check
url = ARGV[0]

# Exit program if no URL is given
if url == 0
    puts "No argument"
    exit(0)
end

# Exit program when incorrect URL is given
if url =~ !URI::regexp
    puts "Incorrect URL"
    exit(0)
end

# Extract the domain from the URL
domain = URI.parse(url).host

# Get the json file from thegreenwebfoundation.org
json = "http://api.thegreenwebfoundation.org/greencheck/" + domain
resp = Net::HTTP.get_response(URI.parse(json))
data = resp.body  
hash = JSON.parse(data)

# Output the result
if hash["green"] == true
    puts "[+] " + url + " was checked and found green"
    if hash["hostedby"] != 0
        puts "[+] This website is hosted by " + hash["hostedby"] + " - " + hash["hostedbywebsite"]
    end
else
    puts "[-] " + url + " was checked and found not green"
end

