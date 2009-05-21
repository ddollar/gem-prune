module Gem; module Prune; class Gem

  attr_reader :name
  attr_reader :versions

  def initialize(name)
    @name     = name
    @versions = []
  end

  def clear_relationships
    versions.each { |v| v.clear_relationships }
  end

end; end; end
