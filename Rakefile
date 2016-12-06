require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: [:setup, :spec]

desc 'Creates a test rails app for the specs to run against'
task :setup do
  source_path = 'spec/dummy'
  template = 'spec/support/dummy_app_template.rb'
  system("rm -rf #{source_path}")
  system(<<-BASH)
    bundle exec rails new #{source_path} -m #{template} --skip-spring --skip-git --skip-turbolinks --skip-test
  BASH
end
