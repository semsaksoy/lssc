
class Config
  def root
    File.dirname(__dir__)
  end

  FILE_PATH = "#{ File.dirname(__dir__)}/config.json"
  attr_reader(*JSON.parse(File.read("#{FILE_PATH}")).keys)

  def initialize
        self.load
  end

  @event_dir_cache = nil

  def load
    j = JSON.parse(File.read(FILE_PATH))
    j.keys.each do |k|
      instance_variable_set("@#{k}", j[k])
    end
  end

  def self.global
    @@global
  end

  @@global = self.new

  def self.humanize secs
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)

        "#{n.to_i} #{name}" unless n.to_i==0
      end
    }.compact.reverse.join(' ')
  end
end