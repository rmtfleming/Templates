# Rake Quick Reference
# by Greg Houston
# http://ghouston.blogspot.com/2008/07/rake-quick-reference.html


# -----------------------------------------------------------------------------
# Running Rake
# -----------------------------------------------------------------------------
# running rake from the command-line:
#   rake --help
#     --help shows all the command-line options, a few are listed here.
#   rake
#     (no arguments, runs the default task)
#     rake uses the script: rakefile, Rakefile, rakefile.rb or Rakefile.rb
#     rake will search parent directories for the file.
#   rake -f build.rb
#     -f specifies the rakefile file to run
#   rake target target2
#     target and target2 are the names of the tasks to run (instead of default)
#   rake -n
#     -n shows a dry-run of which tasks would get called
#   rake -T
#     -T shows all task which have descriptions
#   rake -P
#     -P shows task dependencies

# -----------------------------------------------------------------------------
# Tasks
# -----------------------------------------------------------------------------
task :default => :target
# defines a task named :default
# rake will run :default when no other task is specified on the command line
# => :target, makes the task named :target a prerequisite
# rake will ensure prerequisite tasks have completed before invoking this task

task :target => :source
# defines a task named :target with prerequisite :source
# e.g. rake will ensure :source is invoked before :target

task :source => [:x, :y]
# defines a task named :source
# => [:x, :y] shows how to set multiple prerequisites
# all prerequisites must complete before this task will execute
# right now we have defined a chain of prerequisites
#   :default => :target => :source => [:x, :y]
# invoking :default will first invoke :x, :y, :source, :target 

task :a => :b
task :b => :a
# rake will raise an error if you invoke tasks with circular dependencies:
#   Circular dependency detected: TOP => a => b => a

task :hello_world do
  puts 'hello world!'
end
# task behavior is given as a block of code using "do ... end"
#   dont use ruby's { } block syntax, precedence rules will break it
# when the task is invoked, the block of code is executed

task :target => :z do
  # ruby code
end
# since :target is already defined
#   +adds+ the prerequisite :z
#   +adds+ code to execute when :target is invoked
# tasks in rake have a collection of dependencies 
#   and a collection of blocks to execute

task :target2 => :source
# defines :target2 which also depends on :source
# rake will only invoke :source once, even if both
#   :target and :target2 are invoked
# tasks are only invoked once!

task :example_target do
  puts Rake::Task[:target].inspect
  # Rake::Task holds a collection of all tasks.  Access a task using: [name]

  puts Rake::Task[:target].investigation
  # investigation displays some details about a task.
  # useful for figuring out why a task was called or not.
end

task :target do |t|
  puts t.name    #=>  target
  puts t.class   #=>  Rake::Task
end
# task code blocks can accept an option argument (t in this example)
#   which is a reference to the task object.

task :call_invoke do
  Rake::Task[:target].invoke
end
# calling invoke on a task directly (not recommended).
# :target is only run once, even if invoke is called many times.
# calling invoke will execute the prerequisites of :target

task :call_execute do
  Rake::Task[:target].execute( nil )
end
# execute the task directly (not recommended).
# execute can run :target many times.
# calling execute will +not+ execute prerequisites.

task :example_failure do
  raise 'i do not like green eggs and ham!'
end
# raising an exception is a good way to exit rake with a detailed error message
#   most continuous integration tools will detect the failure

task :copy, :source, :target, :needs => :other_task do |t, args|
  puts "copy #{args.source} to #{args.target}"
  # args[:source] also works
end
# rake 0.8 adds support for task arguments
# 
# task named :copy with arguments :source and :target, depends on :other_task
# t = task object
# args = arguments (instance of Rake::TaskArguments)
#
# command-line usage:
#   rake copy[file1,file2]
#   rake "copy[path with spaces/file1,file2]"
#
# rakefile usage:
#   none (as of rake v0.8.1)
#   calling .invoke and .execute is possible (not recommended)

task :copy_some_files do
  cp 'one_file', 'destination'
  cp 'another_file', 'destination', :verbose => true
end
# rake includes the FileUtils module which has many
#   file system manipulation methods.  FileUtils#cp copies a file.
#   see http://www.ruby-doc.org/core/classes/FileUtils.html
# rake wraps FileUtils in Rake::FileUtils to add the :verbose option

task :additional_commands do
  ruby 'my_ruby_script.rb' # run a ruby interpreter
  sh 'build.bat' # run a shell command
  safe_ln 'fileone.txt', 'filetwo.txt' # link or copy (as supported by OS)
  split_all("a/b/c") #=>  ['a', 'b', 'c'] (split directory into an array)
end
# rake adds a few new commands
#   see http://rake.rubyforge.org/classes/FileUtils.html

multitask :c_and_d_in_parallel => [:c, :d]
# using multitask, immediate prerequisites are invoked on separate threads

# -----------------------------------------------------------------------------
# File and Directory Tasks
# -----------------------------------------------------------------------------
directory 'tests/out'
# defines a directory task named 'tests/out' which will
#   create the 'tests/out' directory if it doesn't
#   already exist.

file 'path/target.txt' => 'path/source.txt' do
  cp 'path/source.txt', 'path/target.txt'
end
# defines a file task named 'path/target.txt' which will
#   get invoked if the file 'path/source.txt' is newer.
# file tasks look at the timestamp of the prerequisites

def copy_file( source_file, target_file, task_symbol )
  desc "cp from #{source_file}"
  file target_file => [source_file] do |t|
    cp source_file, target_file, :verbose => true
  end
  task task_symbol => target_file
end
# example of a method which creates tasks.
# copy_file makes a file task to copy the source_file to target_file
# copy_file make task named task_symbol to depend on the target_file
#
# usage:
copy_file( 'path/foo.txt', 'path/foobar.txt', :copy_foo )

# -----------------------------------------------------------------------------
# FileList
# -----------------------------------------------------------------------------
FileList['data/**/*', 'out/non-existing-file.txt']
# rake FileList can glob files from the disk,
#   and/or collect files that dont exist.
# FileList globs are lazy, they are resolved when first used.

FileList['data/**/*'].exclude('*.txt')
# .exclude globs
# resolves against the file system, e.g. wont match files that don't exist

FileList['data/**/*'].exclude {|path| path =~ /delete_me/ }
# .exclude can use block to exclude everything where the block returns true.
# example: exclude files when path matches the regular expression /delete_me/
# FileList contains many other useful methods.
#   see http://rake.rubyforge.org/classes/Rake/FileList.html

FileList['data/*'].each do |source|
  target = source.sub('data', 'out')
  file target => source do
    cp source, target, :verbose => true
  end
  desc "copies all data files"
  task :copy_data_files => target
end
# example using FileList to create tasks to perform a copy

file 'target.txt' => 'source.txt' do |f|
  cp f.prerequisites[0], f.name, :verbose => true
end
# file tasks blocks can access the task object
#   f.prerequisites[0] is 'source.txt'
#   f.name is 'target.txt'

# -----------------------------------------------------------------------------
# String extensions
# -----------------------------------------------------------------------------
# Rake adds methods to String...
# see http://rake.rubyforge.org/classes/String.html
#
'path/file.txt'.ext( 'html')  #=> path/file.html (replace extension)
'path/file.txt'.pathmap('%p') #=> 'path/file.txt' (full path)
'path/file.txt'.pathmap('%f') #=> 'file.txt' (file)
'path/file.txt'.pathmap('%n') #=> 'file' (file name, no ext)
'path/file.txt'.pathmap('%x') #=> '.txt' (file extension)
'path/file.txt'.pathmap('%X') #=> 'path/file' (full path, no extension)
'x/y/z/file.txt'.pathmap('%d') #=> 'x/y/z' (directory path)
'x/y/z/file.txt'.pathmap('%2d') #=> 'x/y'  (directory path depth 2)
'x/y/z/file.txt'.pathmap('%-2d') #=> 'y/z'  (directory path depth 2 from end)
'x/y/z/file.txt'.pathmap('%d%s%f') #=> 'x/y/z\file.txt' (%s = alt separator)
'x/y/z/file.txt'.gsub('/','\\') #=> 'x\y\z\file.txt' (gsub works better)
''.pathmap('%%') #=> '%' (percent sign)
'a/b/c'.pathmap('%{a,apple}p') #=> 'apple/b/c' use {} to replace using regex
'a/b/c'.pathmap('%{a,x;b,y}p') #=> 'x/y/c' use {;} to replace multiple patterns
'a/b/c'.pathmap('%{a,*}p') {|m| "(#{m})"} #=> '(a)/b/c' * calls block for match

# -----------------------------------------------------------------------------
# Namespace
# -----------------------------------------------------------------------------
namespace :ns do
  task :target
end
task :default => "ns:target"
# defines a namespace named :ns
# defines a task named "ns:target"
# sets "ns:target" as a prerequisite of :default
# use namespace to organize code and avoid task name conflicts

namespace :ns do
  task :alpha => :beta
  task :beta
end
# within a namespace, you can refer to another task in the namespace directly
# you dont need
#   task :alpha => 'ns:beta'

task :dog
task :farmer
namespace :animal do
  task :cat => :dog
  task :dog => :farmer
end
# namespaces will look for tasks within their own namespace
# animal:cat's prerequisite is animal:dog, not :dog
# i dont know of a way to reference :dog instead of animal:dog inside
#   the namespace block. animal:dog hides :dog!
# animal:dog's prerequisite is :farmer (outer scope) since there isn't
#   an animal:farmer defined.

task 'animal:cow' => :dog
# animal:cow is defined outside the namespace block
# animal:cow's prerequisite is :dog, not animal:dog
# animal:cow will look for prerequisites in the outer scope
# animal:cow will not automatically look for tasks in the animal namespace

namespace :animal do
  task :calf => :cow
end
# animal:calf's prerequisite is the 'animal:cow' defined above. as expected.

namespace :demo do
  file 'out/demo.txt' => ['in/demo.txt', :hello]
  task :hello
end
# file task name is only 'out/demo.txt', the namespace doesn't change the name
# however the scope lookup applies, 'out/demo.txt' prereq is demo:hello

# -----------------------------------------------------------------------------
# Rules
# -----------------------------------------------------------------------------
rule /out\/.*\.txt/ => proc {|t| t.pathmap('data/%n.txt')} do |t|
  cp t.source, t.name
end
task :use_rule => 'out/some_file.txt'
# see the rake documentation and tutorials for rules.
# rake allows defining rules, they describe how to generate a file from another
# in practice, i've found rules can get hard to read
# instead i generate tasks using a FileList (more readable)...
FileList.new('data/*.txt').each do |f|
  target = f.pathmap('out/%f')
  file target => f do
    cp f, target, :verbose => true
  end
  task :use_rule => target
end

# -----------------------------------------------------------------------------
# Clean and Clobber
# -----------------------------------------------------------------------------
require 'rake/clean'
# creates two tasks: :clean and :clobber
#   :clean is used to remove temporary files
#   :clobber is used to remove all generated files
# also creates two constants: CLEAN and CLOBBER
#   they are FileLists of files to remove
# :clean is a prerequisite of :clobber
# examples:
CLEAN << 'file_to_remove.txt'
CLEAN.include( '*_to_remove.txt' )
CLEAN.add( 'delete_me.txt' )
CLEAN.exclude( 'dont_remove.txt' )

# -----------------------------------------------------------------------------
# Import and Libraries
# -----------------------------------------------------------------------------
# rakefile usage:
#   import 'more_tasks.rb'
# import is like require, except it loads +after+ the current file is finished.

# the rake command-line can specify a library folder (default is rakelib)
#   rake -R=another_rakelib
# rake will automatically +import+ all *.rake files found in the directory

# -----------------------------------------------------------------------------
# Task Generation
# -----------------------------------------------------------------------------
# Sometimes you want to create a bunch of similar tasks.  Task Generators
# are classes that create tasks.
# 
# For example, building rdoc documentation from ruby source code may
# involve three tasks:
#   rake rdoc         # build rdoc
#   rake clobber_rdoc # remove rdoc output
#   rake rerdoc       # force a rebuild of rdoc
#
# Rake provides a class which creates these tasks from a single call:
#   see http://rake.rubyforge.org/classes/Rake/RDocTask.html
require 'rake/rdoctask'
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

# Rake::TestTask is another task generator, for running ruby unit tests
#   tasks: test (has several command-line options)
#   see http://rake.rubyforge.org/classes/Rake/TestTask.html
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

# Rake::GemPackageTask is another task generator, for packaging gems
#   tasks: "package_dir/name-version.gem"
#   see http://rake.rubyforge.org/classes/Rake/GemPackageTask.html

require 'rubygems'
spec = Gem::Specification.new do |s|
    s.name = 'mygem'
    s.version = '0.1'
    # ...etc ...
end

require 'rake/gempackagetask'
Rake::GemPackageTask.new(spec) do |package|
  package.need_zip = true
end

# Writting your own Task Generator is easy to develop.
# For example, GetPastie will create a task to download a pastie:
require 'rake/tasklib'
class GetPastie < Rake::TaskLib
  attr_accessor :name, :id, :target

  # initialize sets the name and calls a block to get
  #   the rest of the options
  def initialize( name=:get_pastie )
    @name = name
    yield self if block_given?
    define
  end

  # define creates the new task(s)
  def define
    raise "id must be defined" if @id.nil?
    raise "target must be defined" if @target.nil?
    require 'open-uri' 
    desc "download http://pastie.org/pastes/#{@id} to #{target}"
    task @name do
      open(@target,"w").write(open("http://pastie.org/pastes/#{@id}/download").read) 
    end
  end
end

# creates the task :rake_quick_ref
GetPastie.new( :rake_quick_ref ) do |t|
  t.id = 239387 # the first quick ref published
  t.target = 'out/pastie_239387.rb'
end


# -----------------------------------------------------------------------------
# Tips
# -----------------------------------------------------------------------------
# tracing is turned on using the command-line -t flag
#   rake -t
# or within the rake file...
Rake.application.options.trace = true

# name=value pairs given at the end of the command-line are accessible
#   using the ENV hash
#   
# for example:
#   rake mytask CONFIG=DEBUG
task :show_config do
  puts ENV['CONFIG']  #=> DEBUG
end
# for and example of combining command-line args with configuration options
#   see Rake::TestTask

task :x  # referenced above
task :y
task :z

