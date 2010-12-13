RSpec::Matchers.define :roughly_match do |expected|
  match do |actual|
    actual.split(/>\s+</).join("><").strip.should == expected.split(/>\s+</).join("><").strip
  end
  
  description { "should contain HTML roughly equivalent to" }
end
