require 'open3'

require_relative 'directory'
require_relative 'logger'

class Command
  class NonZeroExitError < StandardError
    attr_reader(:status)

    def initialize(status)
      @status = status
      super("Non-Zero exit code: #{status}")
    end
  end

  COMMAND_ENV = {}.freeze

  attr_reader :dir

  def initialize(dir: nil)
    @dir = dir
  end

  def run(*args)
    Logger.inset do
      execute_command(*args)
    end
  end

  private

  def execute_command(*args)
    Logger.trace(Color.yellow('Running'), Color.light_blue(args.join(' ')), Color.yellow('in'), Color.blue(dir))
    status = Open3.popen3(*args, chdir: dir) do |_i, o, e, t|
      Thread.new do
        until o.eof?
          Logger.message(Color.light_blue('->'), o.gets)
        end
      end
      Thread.new do
        until e.eof?
          Logger.message(Color.red('->'), e.gets)
        end
      end
      t.value.to_i
    end
    raise NonZeroExitError.new(status) unless status.zero?
  end
end
