Gem::Specification.new do |s|
  s.name = "couch_scheduler"
  s.summary = "Schedule documents with start and end dates."
  s.version = File.read "VERSION"
  s.authors = "Matt Parker"
  s.email = "moonmaster9000@gmail.com"
  s.homepage = "http://github.com/moonmaster9000/couch_scheduler"
  s.description = "Create a publishing system that allows you to schedule your documents for publication."
  s.add_development_dependency "cucumber"
  s.add_development_dependency "rspec"
  s.add_development_dependency "couchrest_model_config"
  s.add_development_dependency "couch_publish"
  s.add_development_dependency "couch_visible", "~> 0.0.2"
  s.add_development_dependency "timecop"
  s.add_dependency "couchrest_model", "~> 1.0.0"
  s.add_dependency "couch_view", "~> 0.1.1"
  s.files = Dir["lib/**/*"] << "VERSION" << "readme.markdown"
  s.test_files = Dir["features/**/*"]
end
