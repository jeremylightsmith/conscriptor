require_relative 'lib/conscriptor/version'

Gem::Specification.new do |spec|
  spec.name = 'conscriptor'
  spec.version = Conscriptor::VERSION
  spec.authors = ['Jeremy Lightsmith']
  spec.email = ['jeremy.lightsmith@gmail.com']

  spec.summary = 'Helpful utilities for writing scripts in ruby'
  spec.homepage = 'https://github.com/jeremylightsmith/conscriptor'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/jeremylightsmith/conscriptor/issues',
    'changelog_uri' => 'https://github.com/jeremylightsmith/conscriptor/releases',
    'source_code_uri' => 'https://github.com/jeremylightsmith/conscriptor',
    'homepage_uri' => spec.homepage
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
