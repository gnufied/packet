task :doc => [:rdoc]


Rake::RDocTask.new do |rdoc|
  files = ['README', 'MIT-LICENSE', 'CHANGELOG',
           'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = 'README'
  rdoc.title = 'Packet Docs'
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers' << '--inline-source'
end
