require "rubygems/command"
require "rubygems/command_manager"
require "gem/prune/util"

class Gem::Commands::KeepCommand < Gem::Command

  include Gem::Prune::Util

  def initialize
    super 'keep', 'Mark a gem for keeping'
    
    add_option('-v', '--version VERSION', 'Which version to keep',
      '(3.0, >=2.5, ~>1.5)') do |value, options|
      options[:version] = value
    end
  end

  def execute
    keep_gem = get_one_gem_name
    load_configuration
    entry = gems_to_keep.detect { |(gem, versions)| gem == keep_gem }
    entry[1] << options[:version]
    entry[1] = entry[1].uniq.compact
    save_configuration
  end

private ######################################################################

end
