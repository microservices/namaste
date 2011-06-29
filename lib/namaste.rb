require 'i18n'

module Namaste
  # @return [Hash] of Namaste mappings for integer and type value
  DUBLIN_KERNEL = { :type => 0, :who => 1, :what => 2, :when => 3, :where => 4 }
  
  # @return [Hash] of regular expressions matching the Namaste::DUBLIN_KERNAL Hash
  PATTERN = Hash[*Namaste::DUBLIN_KERNEL.map { |k, v| [k, Regexp.new("^#{v}=")]}.flatten]
  
  # @return [Regexp] of standard Namaste file name pattern
  PATTERN_CORE = /^\d=/

  # @return [Regexp] of the possible exteneded Namaste file name pattern
  PATTERN_EXTENDED = /=/

  autoload :Mixin, 'namaste/mixin'
  autoload :Dir, 'namaste/dir'
  autoload :Set, 'namaste/set'
  autoload :Tag, 'namaste/tag'
  
end
