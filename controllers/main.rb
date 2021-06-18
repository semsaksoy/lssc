class Control

  def self.main
    begin

      LogSourceGroup.update
      lg = LogSourceGroup.global
      lgk = lg.keys
      lgk.each do |lsk|
        ls = lg[lsk]
        if ls.stopped != false && (ls.ha_ls.nil? != false || ls.ha_ls.stopped != false)
          if ls.notify?
            print "Notify ", ls.name
            ls.notify_stopped
          end
        end
      end

    rescue => ex
      print ex.message, ex.backtrace
    ensure
      LogSourceGroup.dump
    end
  end

end



