worker_processes 2

app_path = "/var/www/koyabu.com/current"
working_directory app_path

listen '/tmp/koyabu.com.unicorn.sock', :backlog => 64
pid 'tmp/pids/unicorn.pid'

timeout 30

stderr_path File.expand_path('log/unicorn.log', app_path)
stdout_path File.expand_path('log/unicorn.log', app_path)

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

check_client_connection false

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/Gemfile"
end

run_once = true

before_fork do |server, worker|
  if run_once
    # do_something_once_here ...
    run_once = false # prevent from firing again
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
