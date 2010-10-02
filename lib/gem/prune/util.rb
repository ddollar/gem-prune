module Gem; module Prune; module Util

  def settings_filename
    File.expand_path('~/.gem-prune')
  end

  def gems_to_keep
    @configuration
  end

  def load_configuration
    @configuration ||= File.read(settings_filename).split("\n").map do |line|
      gem, versions = line.split(' ', 2)
      versions = versions.to_s.gsub(/[\(\)]/, '').split(', ')
      [gem, versions]
    end
  end

  def save_configuration
    File.open(settings_filename, "w") do |file|
      formatted = @configuration.map do |gem, versions|
        version_string = versions.length.zero? ? "" : " (%s)" % versions.join(", ")
        "#{gem}#{version_string}"
      end.join("\n")

      file.puts formatted
    end
  end

end; end; end
