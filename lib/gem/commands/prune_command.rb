require 'rubygems/command'
require 'rubygems/command_manager'
require 'rubygems/uninstaller'
require 'gem/prune/gem'
require 'gem/prune/version'

class Gem::Commands::PruneCommand < Gem::Command

  def initialize
    super 'prune', 'Identify and remove old gems'
  end

  def execute
    return if leaves.empty?
    leaves.each do |name, versions|
      begin
        question  = "#{name} (#{versions.map { |v| v.version }.join(', ')})\n"
        question << " [k] keep this gem\n"
        question << " [u] uninstall this gem\n"
        question << " [s] skip (default)\n"
        question << "> "
        print question
        case $stdin.gets.chomp
          when 'k' then keep_gem(name)
          when 'u' then uninstall(name)
        end
      rescue Gem::FilePermissionError
        puts 'Unable to uninstall. Try sudo?'
        next
      end
    end
  rescue Exception => ex
    puts "Unhandled Exception: #{ex.message}"
  end

## commands ##################################################################

  def keep_gem(name)
    kept = load_kept_gems
    kept << name
    save_kept_gems(kept.uniq)
  end

  def uninstall(name)
    leaves[name].each do |version|
      uninstaller(name, version.version).uninstall
    end
  end

private ######################################################################

  def gems
    @gems ||= begin
      gems = Gem.source_index.gems.values.inject({}) do |memo, raw|
        next(memo) if ignore_specification(raw)
        gem = memo[raw.name] || Gem::Prune::Gem.new(raw.name)
        gem.versions << Gem::Prune::Version.new(gem, raw)
        memo.update(raw.name => gem)
      end
      discover_relationships(gems)
      gems
    end
  end

  def discover_relationships(gems)
    gems.values.each { |gem| gem.clear_relationships }

    gems.each do |name, gem|
      gem.versions.each do |version|
        version.raw.dependencies.each do |dep|
          next if ignore_dependency(dep)
          next unless gems[dep.name]
          match = gems[dep.name].versions.sort.reverse.detect { |v| dep =~ v }
          next unless match
          match.dependants << version
          version.dependencies << match
        end
      end
    end
  end

  def leaves
    @leaves ||= gems.keys.inject({}) do |memo, name|
      highest_version = gems[name].versions.sort.reverse.first
      leaves = gems[name].versions.select do |version|
        version.dependants.length.zero? &&
        !ignore_version(version) &&
        version != highest_version
      end
      memo[name] = leaves unless leaves.length.zero?
      memo
    end
  end

  def ignore_version(version)
    return true if load_kept_gems.include?(version.gem.name)
    false
  end

  def ignore_specification(specification)
    return true if specification.loaded_from =~ /\/System\/Library/
    false
  end

  def ignore_dependency(dependency)
    false
  end

  def uninstaller(name, version)
    Gem::Uninstaller.new(name, :version => version, :executables => true)
  end

  def load_kept_gems
    YAML::load_file(settings_filename)['keep']
  rescue
    []
  end

  def save_kept_gems(gems)
    File.open(settings_filename, 'w') do |file|
      file.puts({ 'keep' => gems }.to_yaml)
    end
  end

  def settings_filename
    File.expand_path('~/.gem-prune')
  end

end
