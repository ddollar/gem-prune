module Gem; module Prune; class Version

  attr_reader :gem
  attr_reader :raw
  attr_reader :dependants
  attr_reader :dependencies

  def initialize(gem, raw)
    @gem = gem
    @raw = raw

    clear_relationships
  end

  def inspect
    pretty  = %{<Gem::Prune::Version }
    pretty << %{@name="#{name}" }
    pretty << %{@version="#{version}" }
    pretty << %{@dependants="#{dependants.map { |d| "#{d.name}-#{d.version}" }.join(' ') }" }
    pretty << %{@dependencies="#{dependencies.map { |d| "#{d.name}-#{d.version}" }.join(' ') }"}
    pretty << %{>}
  end

  def name
    raw.name
  end

  def version
    raw.version
  end

  def clear_relationships
    @dependants   = []
    @dependencies = []
  end

  def <=>(other)
    version <=> other.version
  end

end; end; end
