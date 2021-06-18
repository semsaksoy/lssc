require "irb"
require "time"
require "json"
require "erb"


require "#{File.dirname(__FILE__)}/models/config.rb"


Dir["#{Config.global.root}/models/*"].each do |m|
  require "#{Config.global.root}/models/#{File.basename(m)}"
end
Dir["#{Config.global.root}/controllers/*"].each do |m|
  require "#{Config.global.root}/controllers/#{File.basename(m)}"
end

Dir.mkdir("#{Config.global.root}/temp") unless Dir.exists?("#{Config.global.root}/temp")

class String
  def to_n
    self.strip.empty? ? nil : self.strip
  end
end


