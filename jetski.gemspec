Gem::Specification.new do |s|
  s.name        = "jetski"
  s.version     = "0.2.4"
  s.summary     = "A simple and fast MVC framework"
  s.description = "Would you rather ride on a train or a jetski? that is the question you might use when comparing using our framework or the popular Ruby on Rails framework. "
  s.authors     = ["Indigo Tech Tutorials"]
  s.email       = "indigo@tech.tut"
  s.files       = [
                    "bin/jetski", 
                    Dir.glob("lib/**/*"), 
                    Dir.glob("templates/**/*")
                  ].flatten
  s.homepage    = "https://rubygems.org/gems/jetski"
  s.license       = "MIT"
  s.metadata['source_code_uri'] = 'https://github.com/indigotechtutorials/jetski'
  s.add_dependency('webrick', '~> 1.9.1')
  s.add_development_dependency('thor', '~> 1.4.0')
  s.executables << "jetski"
end