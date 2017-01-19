class Harmony::Service::Chart::Request < Harmony::Service::Request
  attr_accessor :uri # for source files
  attr_accessor :output_range # range inside source file (i.e. excel)
end