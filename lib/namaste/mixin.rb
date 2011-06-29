module Namaste
  module Mixin
    # define shortcut methods for dublin kernel values
    def self.included(base)
      Namaste::DUBLIN_KERNEL.each do |k,v|
        base.class_eval do
          define_method(k.to_s) do |*args|
            namaste[k]
          end
  
          define_method(k.to_s+'=') do |v|
            namaste[k] = v
          end
        end
      end
    end

    # Get the set of namaste tags for this directory
    # @return [Namaste::Set] 
    def namaste 
      @namaste ||= Namaste::Set.new(self)
    end

    # If a Namaste 'type' tag is defined, provide structured data
    # @return [Struct::Dirtype]
    def dirtype
      type = namaste[:type]
      type.first.dirtype unless type.empty?
    end
  end
end
