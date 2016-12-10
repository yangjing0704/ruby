#!/usr/bin/env ruby
require 'time'
p Dir.pwd
a = *(1..10_000_000)
Time.at(0)

t = Time.now
a.sort!
a.include?(9_000_000)
p Time.now - t




