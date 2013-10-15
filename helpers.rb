# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

require 'cgi'


def downloading?(file)
  
  # Firefox
  return true if file =~ /\.part$/
  return true if File.exist?("#{file}.part")

  # Chrom*
  return true if file =~ /\.crdownload$/

  base_dir, name = File.split file

  # I usually save links in files named 'pending', 'pending-pics'... and
  # download 'em using `wget -ci`
  dir("#{base_dir}/pending*").any? do |links_file|
    
    File.readlines(links_file).any? do |link|
      link_filename = File.basename(link).strip
      
      name == CGI::unescape(link_filename)
    end
    
  end
end


# Same as `Maid::tools#dir`, but without listing files that are (possibly)
# being downloaded.
def dir_safe(expression)

  dir(expression).select do |file|
    not downloading?(file)
  end
end


def versions_of(file)
  directory, filename = File.split file

  v = version_of file

  return [] if v.nil?

  x = filename[0...v[:offset]]

  list = dir_safe("#{directory}/*").select { |y|
    x == File.basename(y)[0...v[:offset]]
  }.select { |x| # Only compare files with a valid version
    version_of x
  }

  list.sort do |f1, f2|
    v1 = version_of f1
    v2 = version_of f2

    if v1.nil? or v2.nil?
      0
    else

      a, b, c = v1[:major], v1[:minor], v1[:patch]
      x, y, z = v2[:major], v2[:minor], v2[:patch]

      if a != x
        a <=> x
      elsif b != y
        b <=> y
      elsif c != z
        c <=> z
      else
        0
      end
    end

  end
end


def version_of(file)
  filename = File.basename file

  match = filename.match /(^[a-zA-Z]+|[\-\.][vr]?)?([0-9]+\.[0-9]+\.[0-9]+)/
  #                        ^^^^^^^^^^^1
  #                                          ^2
  #                                           ^3
  #
  # Regex is based on:
  #
  # 1. Go (a.k.a. "Golang") archives -> "go1.1.2.src.tar.gz"
  #                                       ^^
  # 2. NodeJS archives -> "node-v0.10.18.tar.gz"
  #                             ^^
  # 3. MongoDB archives -> "mongodb-src-r2.4.5.tar.gz"
  #                                     ^^

  return nil unless match

  token_index = 2
  version_token = match[token_index]
  version_array = version_token.split('.').map {|x| Integer(x)}
  version = {
    offset: match.offset(token_index)[0],
  }

  version[:major], version[:minor], version[:patch] = version_array

  return version
end
