require "rspec"

describe "description" do
  it "does something" do
    p "asdSADAsd"
  end

  it "should return help message when no parameters are passed" do
    expect(`ruby ../layout_translator.rb`).to include("Usage: translate_layout")
  end

  it "should return help message when no parameters are passed" do
    expect(`ruby ../layout_translator.rb`).to include("Usage: translate_layout")
  end
end
