#!/usr/bin/env ruby

require 'shellwords'
require 'open3'


title = if ARGV.length > 0 then ARGV[0] else 'really???' end

cmd = "rofi -theme-str 'window {width: 200px; height: 150px;}' -dmenu -p '#{title}' -sep '\\0' -eh 2 -markup-rows -format i"
Open3.popen2(cmd) do |i, o, t|
  i.write("<span size='x-large' weight='heavy'>Yes</span>\0")
  i.write("<span size='x-large' weight='heavy'>No</span>\0")

  # pid = t.pid # pid of the started process.
  exit_status = t.value
  p exit_status
  p o.read
end
