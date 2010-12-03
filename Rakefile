desc 'Delete generated _site files'
task :clean do
  system "rm -fR _site"
end

desc 'Run the jekyll dev server'
task :server do
  system "jekyll --server --auto"
end

desc 'Clean temporary files and run the server'
task :compile => [:clean] do
  system "jekyll --no-auto"
  system "rm _site/Rakefile"
end

desc 'Deploy to production'
task :deploy do
  system "rsync -drv -e ssh _site/ jh@gir.deefa.com:/srv/www/yob.id.au/public/"
end
