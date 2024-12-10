# frozen_string_literal: true

require 'subprocess'
require 'oj'
require 'json'

process = Subprocess::Process.new(
  ['bash', '-c', 'cat > /dev/null'],
  stdin: Subprocess::PIPE,
)

chunk = {"foo":("bar"*1000)}.to_json

if true
  writer = Oj::StreamWriter.new(process.stdin)
  writer.push_array
  1000.times do |i|
    writer.push_json(chunk)
    STDERR.puts "pushed chunk #{i}"
  end
  writer.pop
else
  out = process.stdin
  out.write('[')
  1000.times do |i|
    out.write(",") if i > 0
    out.write(chunk)
    STDERR.puts "pushed chunk #{i}"
  end
  out.write(']')
end
