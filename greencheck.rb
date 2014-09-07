#!/usr/bin/env ruby
# encoding: UTF-8

require "rubygems"
require "json"
require "net/http"

# Exit program if nu url is given
if ARGV.length == 0
    puts "No argument"
    exit(0)
end

# Get the json file from thegreenwebfoundation.org
url  = "http://api.thegreenwebfoundation.org/greencheck/" + String.new(ARGV[0])
resp = Net::HTTP.get_response(URI.parse(url))
data = resp.body  
hash = JSON.parse(data)

# Output the result
if hash["green"] == true
    puts "[+] " + ARGV[0] + " was checked and found green"
    if hash["hostedby"] != 0
        puts "[+] This website is hosted by " + hash["hostedby"]
    end
else
    puts "[-] " + ARGV[0] + " was checked and found not green"
end

