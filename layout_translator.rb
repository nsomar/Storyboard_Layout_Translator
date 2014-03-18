#!/bin/ruby
require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'pathname'
require 'optparse'

def fix_item_in_hash (hash, key, rtl)

  if rtl

    if hash[key].value == "leading"
      hash[key].value = "right"
    end

    if hash[key].value == "trailing"
      hash[key].value = "left"
    end
  else

    if hash[key].value == "leading"
      hash[key].value = "left"
    end

    if hash[key].value == "trailing"
      hash[key].value = "right"
    end

  end

end

def fix_attributes (hash, rtl)
  fix_item_in_hash(hash, "firstAttribute", rtl)
  fix_item_in_hash(hash, "secondAttribute", rtl)

  hash["firstItem"].value, hash["secondItem"].value = hash["secondItem"].value,hash["firstItem"].value if rtl
  hash["firstAttribute"].value, hash["secondAttribute"].value = hash["secondAttribute"].value,hash["firstAttribute"].value if rtl
end

def translate_layout (file_path, rtl, output)

  file_name = File.basename(file_path)
  file_name.slice! File.extname(file_path)
  base_name = File.dirname(File.dirname(file_path))

  if output.nil?
    output = "%s/%s.%s.storyboard"% [base_name , rtl ? "ar" : "en", file_name]
  end

  story_content = File.read(file_path)
  doc  = Nokogiri::XML(story_content)

  constrants = doc.css("constraint")

  p "All constrants #{constrants.count}"

  # Remove all self constraint
  constrants = constrants.select do |constrant|
    constrant.attributes.has_key?"secondAttribute"
  end

  p "All constrants after removing self #{constrants.count}"

  # Remove all top and bottom constraint
  constrants = constrants.select do |constrant|
    value = constrant.attributes["firstAttribute"].value
    (value == "leading") || (value == "trailing")
  end

  p "We have only #{constrants.count} items"

  constrants.each do |item|
    fix_attributes(item.attributes, rtl)
  end

  p output
  File.open(output, 'w') {|f| doc.write_xml_to f}
end

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: translate_layout File [OPTIONS]"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-l", "--ltr", "Left to right") { options["right_to_left"] = false }

  opt.on("-r", "--rtl", "Right to left") { options["right_to_left"] = true }

  opt.on("-o destination", "--output destination", "output destination") do |level|
    options["output"] = level
  end
end

begin
  opt_parser.parse!
rescue Exception => e
  puts e
end

if ARGV.length > 0 && !options.empty?
  translate_layout ARGV[0], options["right_to_left"], options["output"]
else
  puts opt_parser
end
