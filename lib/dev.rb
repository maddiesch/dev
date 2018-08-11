require_relative 'command'
require_relative 'logger'
require_relative 'color'
require_relative 'directory'

class Dev
  class << self
    def run(command, *args)
      case command
      when 'start', 'up'
        Logger.message(Color.green('Starting Containers'))
        cmd = Command.new(dir: Directory.docker)
        cmd.run('docker-compose', '--no-ansi', 'up', '-d', *args)
      when 'stop'
        Logger.message(Color.green('Stopping Containers'))
        cmd = Command.new(dir: Directory.docker)
        cmd.run('docker-compose', '--no-ansi', 'stop', *args)
      when 'kill'
        Logger.message(Color.green('Killing Containers'))
        cmd = Command.new(dir: Directory.docker)
        cmd.run('docker-compose', '--no-ansi', 'kill', *args)
      when 'build'
        Logger.message(Color.green('Building Containers'))
        cmd = Command.new(dir: Directory.docker)
        cmd.run('docker-compose', '--no-ansi', 'build', *args)
      when 'help'
        print_help
      else
        raise "Unknown command #{command}. Try `dev help`"
      end
    end

    private

    def command_helps
      [
        ['start', 'start the docker containers'],
        ['stop', 'stops the docker containers'],
        ['kill', 'kills all the running docker containers'],
        ['build', 'builds all the containers'],
        ['help', 'print this help message']
      ]
    end

    def print_help
      Logger.message('dev services for building web apps')
      Logger.break
      Logger.message(Color.green('Commands'))
      Logger.inset do
        command_helps.each do |(name, text)|
          Logger.message(Color.green(name), '-', text)
        end
      end
    end
  end
end
