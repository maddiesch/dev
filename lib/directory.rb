require 'pathname'

class Directory
  class << self
    def base
      Pathname.new(File.expand_path(File.join(__dir__, '..')))
    end

    def method_missing(sel, *args)
      path = base.join(sel.to_s)
      if File.directory?(path)
        path
      else
        super
      end
    end
  end
end
