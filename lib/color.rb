class Color
  class << self
    def disable!
      @disabled = true
    end

    def colorize(str, color_code)
      return str if @disabled
      "\e[#{color_code}m#{str}\e[0m"
    end

    def red(*args)
      colorize(args.join(' '), 31)
    end

    def green(*args)
      colorize(args.join(' '), 32)
    end

    def yellow(*args)
      colorize(args.join(' '), 33)
    end

    def blue(*args)
      colorize(args.join(' '), 34)
    end

    def pink(*args)
      colorize(args.join(' '), 35)
    end

    def light_blue(*args)
      colorize(args.join(' '), 36)
    end
  end
end
