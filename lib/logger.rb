require_relative 'color'

class Logger
  INSET = '  '.freeze

  class << self
    def default(logger = nil)
      @logger = logger if logger
      @logger ||= Logger.new(STDOUT, STDERR)
    end

    def method_missing(sel, *args, &block)
      if default.respond_to?(sel)
        default.send(sel, *args, &block)
      else
        super
      end
    end
  end

  def initialize(out, err, trace: false)
    @out = out
    @err = err
    @depth = 0
    @trace = trace
  end

  def inset
    @depth += 1
    yield
  ensure
    @depth -= 1
  end

  def message(*args)
    padding = INSET * @depth
    @out.puts(padding + args.join(' '))
  end

  def trace(*args)
    return unless @trace
    message(Color.yellow('TRACE:'), *args)
  end

  def error(*args)
    padding = INSET * @depth
    @err.puts(padding + Color.red('[ERROR]:', args.join(' ')))
  end

  def break
    message("\n")
  end
end
