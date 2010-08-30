require 'gem/commands/keep_command'
require 'gem/commands/prune_command'

Gem::CommandManager.instance.register_command :keep
Gem::CommandManager.instance.register_command :prune