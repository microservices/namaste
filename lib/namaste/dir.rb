module Namaste
  class Dir < ::Dir
    autoload :Extend, 'namaste/dir/extend'

    include Namaste::Mixin

  end
end
