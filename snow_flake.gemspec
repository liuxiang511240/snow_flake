lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "snow_flake/version"

Gem::Specification.new do |spec|
  spec.name = "snow_flake"
  spec.version = SnowFlake::VERSION
  spec.authors = ["liuxiangping"]
  spec.email = ["liuxiang511240@163.com"]

  spec.summary = %q{snowflake generate ID}
  spec.description = %q{This is a gem can generate ID using SnowFlake. The advantage of SnowFlake is that it is sorted by time increment on the whole, and there is no ID collision
(distinguished by data center ID and machine ID) in the whole distributed system, and it is more efficient.
After testing, SnowFlake can generate about 260,000 IDs per second}
  spec.homepage = "https://rubygems.org/gems/snow_flake"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) {|f| File.basename(f)}
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
