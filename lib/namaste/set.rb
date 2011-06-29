module Namaste
  class Set
    # @param [Dir] dir
    def initialize(dir)
      @dir = dir
    end

    # Get all the namaste tags for the directory
    # @return [Array<Namaste::Tag>]  
    def all
      select
    end

    # Get only select namaste tags for the directory
    # @return [Array<Namaste::Tag>]  
    def [] key = nil
      select(key) 
    end

    # Set a namaste tag
    # @param [String] key
    # @param [String] value
    def []= key, value
      Namaste::Tag.new(@dir.path, key, value)
    end


    private
    def select key = nil
      rgx = Namaste::PATTERN[key] if key.is_a? Symbol and Namaste::PATTERN.key?(key)
      rgx ||= Regexp.new("^#{Regexp.escape(key)}=") if key.is_a? String
      rgx ||= Regexp.new("^#{key}=") if key.is_a? Integer
      rgx ||= Namaste::PATTERN_EXTENDED if key == :extended
      rgx ||= Namaste::PATTERN_CORE if key == nil
      @dir.select { |x| x =~ rgx }.map { |x| Tag.new(File.join(@dir.path, x)) }
    end
  end
end
