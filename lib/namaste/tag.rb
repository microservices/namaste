module Namaste
  class Tag
    # Create a filename for a namaste key/value pair
    # @return [String]
    def self.filename tag, value
      n = "%s=%s" % [tag, self.elide(value)]
      n = n.slice(0...252) + "..." if n.length > 255
      n
    end

    # @param [Directory, File] directory_or_file
    # @param [String] tag
    # @param [String] value
    def initialize(directory_or_file, tag = nil, value = nil)
      directory_or_file = File.expand_path(directory_or_file)

      tag = Namaste::DUBLIN_KERNEL[tag] if tag.is_a? Symbol

      if File.directory?(directory_or_file)
        @dir = directory_or_file
        @tag = tag.to_s
        @value = value.to_s
        write!
      elsif File.file?(directory_or_file)
        @file = File.new(directory_or_file, "a+")
        @dir = File.dirname(@file.path)
      else
        raise "Unknown directory or file (#{directory_or_file.to_s})"
      end

      load_tag_extensions
    end

    # @return [String] namaste value
    def value
      file.rewind
      @value ||= file.read
    end

    # @param [String] value
    def value=(value)
      delete
      @value = value.to_s
      write!
    end

    # @return [String] namaste tag
    def tag
      @tag ||= File.basename(file.path).split("=").first
    end

    # @param [String] namaste tag
    def tag=(tag)
      delete
      @tag = tag.to_s
      write!
    end

    # Delete this tag
    def delete
      @value = value # make sure to preserve the value after the tag is deleted
      File.delete(file.path)
      @file = nil
    end

    private
    def file
      @file ||= File.new(File.join(@dir, filename), "a+")
    end

    def filename
      self.class.filename(@tag, @value)
    end

    # write the namaste tag to the filesystem
    def write!
      file.rewind
      file.write(value)
      file.flush
      file.truncate(file.pos)
      file.rewind
    end

    # transliterate and truncate the namaste value
    def elide
      self.class.elide(@value)
    end

    protected
    # transliterate and truncate the value
    # @param [String] value
    # @return [String] ASCII string
    def self.elide value
      value = I18n.transliterate value
      value.gsub!(/[^A-Za-z0-9\-\._]+/, '_')
      value.gsub!(/_{2,}/, '_')
      value.gsub!(/^_|_$/, '_')
      encoded_value = value.downcase
    end

    private
    def load_tag_extensions
      case tag
        when "0"
          self.extend(Dirtype)
          
      end
    end

    module Dirtype
      # @return [Struct::Dirtype] Parses the namaste 'type' tag to provide structured data (#full, #name, #major, #minor) 
      def dirtype
        v = value
        matches = /([^_\/]+)[_\/](\d+)\.(\d+)/.match(v)  

        if matches
          Struct.new("Dirtype", :full, :name, :major, :minor)
          Struct::Dirtype.new(*matches)
        end
      end
    end
  end
end
