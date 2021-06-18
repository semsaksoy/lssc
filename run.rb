require_relative "env"

begin
  LogSourceGroup.load

  while true
    Control.main
    sleep Config.global.control_frequency * 60
  end

rescue => ex

  print ex.message, ex.backtrace
end


# mv /opt/lssc/lssc.service /lib/systemd/system -v
#  yes | cp -rf /root/LSSC/* /opt/lssc/
