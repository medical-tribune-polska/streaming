$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "streaming/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = "streaming"
  spec.version       = Streaming::VERSION
  spec.authors       = ["Dmytro Koval"]
  spec.email         = ["dawidofdk@gmail.com"]
  spec.summary       = %q{Streaming functionality for MT projects with analytics}
  spec.description   = %q{Streaming functionality for MT projects with analytics}
  spec.homepage      = "https://github.com/medical-tribune-polska/streaming"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_development_dependency 'rails', '>= 4.2', '< 5'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pg', '~> 0.18'
  spec.add_development_dependency 'haml'
  spec.add_development_dependency 'web-console'

  spec.add_runtime_dependency 'paperclip'
  spec.add_runtime_dependency 'kaminari', '~> 1.1'
  spec.add_runtime_dependency 'font-awesome-rails', '~> 4.7'
  spec.add_runtime_dependency 'jquery-rails'
  spec.add_runtime_dependency 'jquery-ui-rails'
  spec.add_runtime_dependency 'momentjs-rails'
  spec.add_runtime_dependency 'bootstrap3-datetimepicker-rails'
  spec.add_runtime_dependency 'tinymce-rails'
  spec.add_runtime_dependency 'select2-rails'

  spec.add_runtime_dependency 'ransack'
  spec.add_runtime_dependency 'rubyzip', '~> 1.1.0'
  spec.add_runtime_dependency 'axlsx', '2.1.0.pre'
  spec.add_runtime_dependency 'axlsx_rails'
  spec.add_runtime_dependency 'chartjs-ror'
  spec.add_runtime_dependency 'summernote-rails', '0.8.8.0'
  spec.add_runtime_dependency 'bootstrap-sass'
  spec.add_runtime_dependency 'sass-rails'
  spec.add_runtime_dependency 'sass'
end
