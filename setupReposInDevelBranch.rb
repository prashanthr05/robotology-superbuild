#!/usr/bin/env ruby

require 'open3'

folders = IO.readlines('./reposInDevelBranch.txt')

Dir.chdir('./robotology')

for folder in folders
  folder = folder.gsub("\n","")
  Dir.chdir(folder)
  puts folder
  Open3.popen3('git log --no-walk --oneline && git branch --contains HEAD') {|_stdin, stdout, _stderr, _wait_thr| puts stdout.read}
  Open3.popen3('git checkout devel') {|_stdin, stdout, _stderr, _wait_thr| puts stdout.read}
  Open3.popen3('git pull origin devel') {|_stdin, stdout, _stderr, _wait_thr| puts stdout.read}
  Open3.popen3('git status') {|_stdin, stdout, _stderr, _wait_thr| puts stdout.read}
  Dir.chdir('..')
end
