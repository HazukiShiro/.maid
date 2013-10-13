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

WINAMP_SKINS = "#{DOWNLOADS}/winamp-skins"
CHROME_FILES = "#{DOWNLOADS}/chrome-related"

DOWNLOADED_RENDERS = "#{DOWNLOADS}/renders"
DOWNLOADED_C4D = "#{DOWNLOADS}/c4d"

LOSSY_PICS = "#{DOWNLOADED_PICTURES}/lossy"
LOSSLESS_PICS = "#{DOWNLOADED_PICTURES}/lossless"
IMAGE_PACKS = "#{DOWNLOADED_PICTURES}/archives"

DOWNLOADED_SOFTWARE_BUILDS = "#{DOWNLOADED_SOFTWARE}/builds"
DOWNLOADED_SOFTWARE_SOURCES = "#{DOWNLOADED_SOFTWARE}/sources"

LEGACY_SOFTWARE_SOURCES = "#{DOWNLOADED_SOFTWARE_SOURCES}/_legacy"


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

  LEGACY_SOFTWARE_SOURCES,
  
  LOSSY_PICS,
  LOSSLESS_PICS,
  IMAGE_PACKS,
  
  WINAMP_SKINS,
  CHROME_FILES,
  
  # These are not on vars. I'm pretty sure I won't change these
  # dirs.
  File.expand_path('~/Downloads/konachan'),
  File.expand_path('~/Downloads/yandere'),
  File.expand_path('~/Downloads/cuanta-razon'),
].each do |path|
  Dir.mkdir(path) unless Dir.exist?(path)
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
  
  
  rule 'Downloaded Chrome files' do
  
    dir_safe( "~/Downloads/*.crx" ).each do |file|
      move file, CHROME_FILES
    end
  end
  
  
  rule 'Downloaded Winamp skins' do
  
    dir_safe( "~/Downloads/*.wal" ).each do |file|
      move file, WINAMP_SKINS
    end
  end
  
  
  rule 'Downloaded pics archives' do
  
    dir_safe( "~/Downloads/*.zip" ).select do |file|
      images = 0
      no_images = 0
      
      zipfile_contents(file).each do |f|
        unless f =~ /\/$/
          if f =~ /\.(png|jpe?g)$/
            images += 1
          else
            no_images += 1
          end
        end
      end
      
      select = nil
      
      # 100% images
      select = true if images > 0 and no_images == 0
      
      if select.nil?
      
        if images == 0
        
          select = false
          
        elsif no_images > 0
          
          ratio = images / no_images
          
          select = true if ratio > 3
          
        end
      end
      
      select
      
    end.each do |file|
      move file, IMAGE_PACKS
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

      elsif filename =~ /^CR_[0-9]+/

        move file, '~/Downloads/cuanta-razon'
        
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

        if filename =~ /[\-_][rv]?[0-9]+[\-\._][0-9]+[\-\._][0-9]+[\-\._]/
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

  rule 'Legacy software archives' do
    dir("#{DOWNLOADED_SOFTWARE_SOURCES}/*").select do |file|
      versions = versions_of file
      if versions.length > 1
        file != versions.pop
      else
        false
      end
    end.each do |file|
      move file, LEGACY_SOFTWARE_SOURCES
    end
    
  end

end
