worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 25
preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true
 
before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|

  if defined?(EventMachine)
    unless EventMachine.reactor_running? && EventMachine.reactor_thread.alive?
      if EventMachine.reactor_running?
        EventMachine.stop_event_loop
        EventMachine.release_machine
        EventMachine.instance_variable_set("@reactor_running",false)
      end
      Thread.new { EventMachine.run }
    end
  end
 
  Signal.trap("INT") { 
    EventMachine.stop 
  }
  Signal.trap("TERM") { 
    EventMachine.stop 
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  }

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
