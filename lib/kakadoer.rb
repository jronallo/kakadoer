require 'rubygems'
require 'mini_magick'
require 'tempfile'

require 'kakadoer/shared'
require 'kakadoer/command'
require 'kakadoer/batch'


module Kakadoer
  KAKADU_OPTIONS = '-rate 0.5 Clayers=1 Clevels=7 "Cprecincts={256,256},{256,256},{256,256},{128,128},{128,128},{64,64},{64,64},{32,32},{16,16}" "Corder=RPCL" "ORGgen_plt=yes" "ORGtparts=R" "Cblk={32,32}" Cuse_sop=yes'

  class MalformedImageError < RuntimeError
  end

end

