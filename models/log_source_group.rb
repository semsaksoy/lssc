class LogSourceGroup

  # attr_reader :name, :Go, :notify_limit_min, :interval_min, :stopped_min, :log_sources
  @hafiza

  def self.update
    log_sources = Hash.new
    groups = Config.global.groups.keys
    groups = groups.map { |z| "'#{z}'" }.join(",")
    # id | group name | log source name | identifier | last_seen | eps60s
    cmd = "sudo psql -P pager=off -t -Aq -F '||' -U qradar -c \"select sensordevice.id,fgroup.name, sensordevice.devicename, sensordevice.hostname,
sensordevice.timestamp_last_seen,sensordevice.eps60s,sensordevice.devicedescription,sensordevice.creationdate
from sensordevice join fgroup_link on cast (fgroup_link.item_id as int) = sensordevice.id
join fgroup on fgroup_link.fgroup_id = fgroup.id where fgroup.type_id = 1
AND deviceenabled='t' and sourcecomponentid is null AND devicetypeid<>246 and fgroup.name in (#{groups});\"  2>/dev/null"
    db_out = `#{cmd}`
    db_out = db_out.split("\n")
    db_out_keys = Array.new
    db_out.each do |c|
      c = c.split("||")

      id = c[0].to_i
      db_out_keys.push id

      ls = (@hafiza[id] if @hafiza) || LogSource.new
      #print @hafiza
      ls.id = c[0].to_i
      ls.group_name = c[1].strip
      ls.name = c[2].strip
      ls.identifier = c[3].strip
      ls.last_seen = Time.strptime(c[4].strip, '%Q') unless c[4].to_i == 0
      ls.eps = c[5].strip
      ls.description = c[6].strip if c[6]
      ls.creation_date = Time.strptime(c[7].strip, '%Q') unless c[7].to_i == 0
      ls.config = Config.global.groups[ls.group_name]
      log_sources[id] = ls

    end

    expired = log_sources.keys - db_out_keys
    expired.each do |e|
      log_sources[e].remove
    end


    @hafiza = log_sources

  end

  def self.global
    @hafiza
  end


  def self.dump
    File.open(Config.global.root + "/temp/save.mars", "w") { |to_file| Marshal.dump(@hafiza, to_file) }
  end

  def self.load
    @hafiza = File.open(Config.global.root + "/temp/save.mars", "r") { |from_file| Marshal.load(from_file) } if File.exist?(Config.global.root + "/temp/save.mars")
  end

end
