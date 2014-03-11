#!/bin/ruby
require "nokogiri"
require 'pathname'

def fix_item_in_hash (hash, key, arabic)

  if arabic

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

def fix_attributes (hash, arabic)
  fix_item_in_hash(hash, "firstAttribute", arabic)
  fix_item_in_hash(hash, "secondAttribute", arabic)

  hash["firstItem"].value, hash["secondItem"].value = hash["secondItem"].value,hash["firstItem"].value if arabic
  hash["firstAttribute"].value, hash["secondAttribute"].value = hash["secondAttribute"].value,hash["firstAttribute"].value if arabic
end

def translate_layout (arabic)

  file_path = "/Users/omar/Documents/iOS/BBB/POC/POC/Base.lproj/Main.storyboard"
  file_name = File.basename(file_path)
  file_name.slice! File.extname(file_path)
  file_english = "%s/%s.en.storyboard"% [File.dirname(File.dirname(file_path)), file_name]
  file_arabic = "%s/%s.ar.storyboard"% [File.dirname(File.dirname(file_path)), file_name]

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

    fix_attributes(item.attributes, arabic)
  end

  p arabic ? file_arabic : file_english
  File.open(arabic ? file_arabic : file_english,'w') {|f| doc.write_xml_to f}

end

translate_layout false
translate_layout true
