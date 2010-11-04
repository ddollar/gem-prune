require "rubygems/command"
require "rubygems/command_manager"
require "rubygems/uninstaller"
require "gem/prune/gem"
require "gem/prune/version"
require "gem/prune/util"

class Gem::Commands::PruneCommand < Gem::Command

  include Gem::Prune::Util

  def initialize
    super 'prune', 'Identify and remove old gems'
  end

  def execute
    load_configuration
    mark_kept_versions
    versions_to_prune.each do |version|
      ui = Gem::Uninstaller.new(version.name, :version => version.version,
        :ignore => true, :executables => true)
      ui.uninstall
    end
    save_configuration
  end

private ######################################################################

  def gems
    @gems ||= begin
      gems = Gem.source_index.gems.values.inject({}) do |memo, raw|
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
          next unless gems[dep.name]
          match = gems[dep.name].versions.sort.reverse.detect { |v| dep =~ v }
          next unless match
          match.dependants << version
          version.dependencies << match
        end
      end
    end
  end

  def mark_kept_versions
    gems.each do |name, gem|
      gems_versions = gems_to_keep.detect { |g| g.first == name }
      versions = gems_versions ? gems_versions.last : []
      if versions.include?("^")
        puts "weee"
        versions.delete("^")
      else
        mark_kept(gem.versions.sort.last)
      end
    end
    gems_to_keep.each do |name, keep|
      keep = [">= 0"] if keep.empty?
      keep.each do |req|
        next unless gems[name]
        requirement = Gem::Requirement.new(req)
        gem_to_keep = gems[name].versions.select do |v|
          requirement.satisfied_by?(Gem::Version.new(v.version))
        end.sort.last
        mark_kept(gem_to_keep) if gem_to_keep
      end
    end
  end

  def mark_kept(version)
    return if version.keep
    version.keep = true
    version.dependencies.each { |v| mark_kept(v) }
  end

  def versions_to_prune
    gems.map { |name, gem| gem.versions }.flatten.select { |v| v.keep == false }
  end

end
