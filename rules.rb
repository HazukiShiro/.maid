# coding: utf-8
#
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

require File.expand_path('../helpers', __FILE__)


DOWNLOADS = File.expand_path '~/Downloads'

DOWNLOADED_PICTURES = "#{DOWNLOADS}/pictures"
DOWNLOADED_VECTORS = "#{DOWNLOADS}/vectors"
DOWNLOADED_MUSIC = "#{DOWNLOADS}/music"
DOWNLOADED_ARCHIVES = "#{DOWNLOADS}/archives"
DOWNLOADED_TARBALLS = "#{DOWNLOADS}/tarballs"
DOWNLOADED_DOCUMENTS = "#{DOWNLOADS}/documents"
DOWNLOADED_SOFTWARE = "#{DOWNLOADS}/software"

DOWNLOADED_RENDERS = "#{DOWNLOADS}/renders"
DOWNLOADED_C4D = "#{DOWNLOADS}/c4d"

LOSSY_PICS = "#{DOWNLOADED_PICTURES}/lossy"
LOSSLESS_PICS = "#{DOWNLOADED_PICTURES}/lossless"

DOWNLOADED_SOFTWARE_BUILDS = "#{DOWNLOADED_SOFTWARE}/builds"
DOWNLOADED_SOFTWARE_SOURCES = "#{DOWNLOADED_SOFTWARE}/sources"


C4D_REGEXP = /^c4d[\-\._]|[\-\._]c4d[\-\._]/i


[
  DOWNLOADED_PICTURES,
  DOWNLOADED_VECTORS,
  DOWNLOADED_MUSIC,
  DOWNLOADED_ARCHIVES,
  DOWNLOADED_TARBALLS,
  DOWNLOADED_DOCUMENTS,
  DOWNLOADED_SOFTWARE,
  
  DOWNLOADED_RENDERS,
  DOWNLOADED_C4D,
  
  DOWNLOADED_SOFTWARE_BUILDS,
  DOWNLOADED_SOFTWARE_SOURCES,
  
  LOSSY_PICS,
  LOSSLESS_PICS,
  
  File.expand_path('~/Downloads/konachan'),
  File.expand_path('~/Downloads/yandere'),
].each do |x|
  Dir.mkdir(x) unless Dir.exist?(x)
end


Maid.rules do


  rule 'Downloaded docs' do
    
    [
      'pdf',
      'odt',
      'doc',
      'docx',
    ].each do |ext|
    
      dir_safe( "~/Downloads/*.#{ext}" ).each do |file|
        move file, DOWNLOADED_DOCUMENTS
      end
    end
  end


  rule 'Downloaded pics' do
    
    [
      'png',
      'jpg',
      'jpeg',
      'gif',
    ].each do |ext|
    
      dir_safe( "~/Downloads/*.#{ext}" ).each do |file|
        move file, DOWNLOADED_PICTURES
      end
    end
  end


  rule 'Downloaded vectors' do
    
    [
      'svg',
      'ai',
    ].each do |ext|
    
      dir_safe( "~/Downloads/*.#{ext}" ).each do |file|
        move file, DOWNLOADED_VECTORS
      end
    end
  end


  rule 'Downloaded music' do
    
    [
      'ogg',
      'mp3',
    ].each do |ext|
    
      dir_safe( "~/Downloads/*.#{ext}" ).each do |file|
        move file, DOWNLOADED_MUSIC
      end
    end
  end


  rule 'Downloaded archives' do
  
    [
      'zip',
      'rar',
    ].each do |ext|
    
      dir_safe( "~/Downloads/*.#{ext}" ).each do |file|
        move file, DOWNLOADED_ARCHIVES
      end
    end
    
    [
      'tar',
      'tar.gz',
      'tar.bz2',
      'tar.xz',
      'tgz',
    ].each do |ext|
    
      dir_safe( "~/Downloads/*.#{ext}" ).each do |file|
        move file, DOWNLOADED_TARBALLS
      end
    end
  end


  rule 'Organize pics' do
    
    dir("#{DOWNLOADED_PICTURES}/*").each do |file|
      
      filename = File.basename file
      
      if filename =~ /^konachan/i
      
        move file, '~/Downloads/konachan'
        
      elsif filename =~ /^yande[\.\-]re/i
      
        move file, '~/Downloads/yandere'
        
      elsif filename =~ /\.png$/
      
        move file, LOSSLESS_PICS
      
      elsif filename =~ /\.jpe?g$/
      
        move file, LOSSY_PICS
        
      end
      
    end
    
    dir("#{LOSSLESS_PICS}/*").each do |file|
      
      filename = File.basename file
      
      if filename =~ C4D_REGEXP
        move file, DOWNLOADED_C4D
      elsif filename =~ /^[\-\._]?render[\-\._]/i
        move file, DOWNLOADED_RENDERS
      end
      
    end
    
    dir("#{LOSSY_PICS}/*").each do |file|
      
      filename = File.basename file
      
      if filename =~ C4D_REGEXP
        move file, DOWNLOADED_C4D
      end
      
    end
    
  end


  rule 'Organize software archives' do
  
    [
      DOWNLOADED_ARCHIVES,
      DOWNLOADED_TARBALLS,
    ].each do |directory|
      dir("#{directory}/*").each do |file|
        
        filename = File.basename(file)

        if filename =~ /[\-_]v?[0-9]+[\-\._][0-9]+[\-\._][0-9]+[\-\._]/
          move file, DOWNLOADED_SOFTWARE
        end
      end
    end
    
    dir("#{DOWNLOADED_SOFTWARE}/*").each do |file|
      
      filename = File.basename(file)
      
      if filename =~ /[\-\._](x86(_64)?|x64|amd64|linux)/
        move file, DOWNLOADED_SOFTWARE_BUILDS
      elsif filename =~ /[\-\._]src[\-\._]/
        move file, DOWNLOADED_SOFTWARE_SOURCES
      end
    end
  end

end
