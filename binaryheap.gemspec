Gem::Specification.new do |s|
  s.author      = 'Hailong Cao'
  s.name        = 'binaryheap'
  s.version     = '1.1.0'
  s.date        = '2018-11-09'
  s.summary     = "binary heap implementation"
  s.description = <<-EOF
    A standard binary heap implementation in ruby.
    Internally, it uses an array as data store and a mutex to keep insert and eject opeations thread-safe (both on CRuby and JRuby).
  EOF
  s.email       = 'hailengc@gmail.com'
  s.files       = ["lib/binaryheap.rb"]
  s.homepage    = 'https://github.com/hailengc/binaryheap'
  s.license     = 'MIT'
end