require "bundler/gem_tasks"
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs.push ["spec","lib"]
  t.test_files = FileList['spec/*_spec.rb', 'spec/**/*_spec.rb']
  t.verbose = true
end
