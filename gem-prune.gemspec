# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gem-prune}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Dollar"]
  s.date = %q{2009-06-15}
  s.default_executable = %q{gem-prune}
  s.email = %q{<ddollar@gmail.com>}
  s.executables = ["gem-prune"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "lib/gem/commands/prune_command.rb",
     "lib/gem/prune/gem.rb",
     "lib/gem/prune/version.rb",
     "lib/rubygems_plugin.rb"
  ]
  s.homepage = %q{http://github.com/ddollar/gem-prune}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Identify and remove old Rubygems}
  s.test_files = [
    "spec/gem-prune_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
