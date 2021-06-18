class LogSource
  attr_accessor :id, :name, :group_name, :identifier, :last_seen, :eps, :description, :creation_date, :last_notify_time, :config, :state

  def get_binding
    binding
  end

  def ha_ls
    LogSourceGroup.global.values.select { |z| z.description.include?("ha:#{self.name};") }.first
  end

  def stopped
    tolerance = self.config["stop_tolerance"].to_i * 60
    lseen = self.last_seen || self.creation_date || Time.at(0)
    if Time.now > lseen + tolerance
      return "-" if (self.last_seen.nil? && self.creation_date.nil?)
      return Config.humanize(Time.now - lseen)
    else
      if self.state == "stopped"
        self.state = "running"
        if self.config["notify_clean"] == true
          self.notify_running
          self.last_notify_time = nil
        end
      end

      false
    end
  end

  def notify?
    notify_frequency = self.config["notify_frequency"].to_i * 60
    if Time.now > (self.last_notify_time || Time.at(0)) + notify_frequency
      true
    else
      false
    end
  end


  def notify_stopped
    #@ls = self
    renderer = ERB.new(File.read("#{Config.global.root}/views/mail_stopped.erb"))
    content = renderer.result(binding).gsub("\'", "\"")
    cmd = "(echo 'To: #{self.config["receiver"].join(',')}'
echo 'From: #{Config.global.sender}'
echo 'Subject: #{Config.global.subject_stopped} #{self.name}'
echo 'Content-Type: text/html'
echo;
echo '#{content}' ) | sendmail -t"
    begin
      #print cmd
      `#{cmd}`
    rescue => ex
      print ex.message, "\n"
    end
    self.last_notify_time = Time.now
    self.state = "stopped"
  end

  def notify_running
    #@ls = self
    renderer = ERB.new(File.read("#{Config.global.root}/views/mail_running.erb"))
    content = renderer.result(binding).gsub("\'", "\"")
    cmd = "(echo 'To: #{self.config["receiver"].join(',')}'
echo 'From: #{Config.global.sender}'
echo 'Subject: #{Config.global.subject_running} #{self.name}'
echo 'Content-Type: text/html'
echo;
echo '#{content}' ) | sendmail -t"
    begin
      `#{cmd}`
    rescue => ex
      print ex.message, "\n"
    end

  end

end