require 'rubygems/command'
require 'rubygems/command_manager'

class Gem::Commands::KeepCommand < Gem::Command

  def initialize
    super 'keep', 'Mark a gem for keeping'
    
    add_option('-v', '--version VERSION', 'Which version to keep',
      '(3.0, >=2.5, ~>1.5)') do |value, options|
      options[:version] = value
    end
  end

  def execute
    gem = get_one_gem_name
    load_configuration
    gems_to_keep[gem] ||= []
    gems_to_keep[gem]  << options[:version]
    gems_to_keep[gem]   = gems_to_keep[gem].uniq.compact
    save_configuration
  end

private ######################################################################

  def load_configuration
    @configuration ||= begin
      config = YAML::load_file(settings_filename)
      config = upgrade_configuration(config) if config.first.first == "keep"
      unpack_configuration(config)
    end
  end

  def save_configuration
    File.open(settings_filename, "w") do |file|
      file.puts(YAML::dump(pack_configuration(@configuration)))
    end
  end

  def unpack_configuration(config)
    config.inject({}) do |memo, (gem, keep)|
      memo.update(gem => keep)
    end
  end

  def pack_configuration(config)
    config.map do |gem, keep|
      [gem, keep]
    end.sort_by(&:first)
  end

  def upgrade_configuration(config)
    config["keep"].map do |gem|
      [gem, []]
    end
  end

  def gems_to_keep
    @configuration
  end

  def settings_filename
    File.expand_path('~/.gem-prune')
  end

end
