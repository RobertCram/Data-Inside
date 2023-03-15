require 'net/sftp'

class Ftp

  FtpFile = Struct.new(:Name, :Body, :Id)

  def self.ftp_settings settings
    @@ftp_settings = settings
  end

  def self.upload_files(path, files)
    Net::SFTP.start(@@ftp_settings[:host], @@ftp_settings[:username], :port => @@ftp_settings[:port], :password => @@ftp_settings[:password]) do |sftp|
      files.each do | file |
        sftp.upload!(StringIO.new(file.Body), File.join(path, file.Name))
        yield file if block_given?
      end
    end
  end

  def self.download_files(path, mask)
    files = Array.new
    Net::SFTP.start(@@ftp_settings[:host], @@ftp_settings[:username], :port => @@ftp_settings[:port], :password => @@ftp_settings[:password]) do |sftp|
      filenames = sftp.dir.glob(path, mask).map { |entry| entry.name}
      filenames.each do | filename |
        filebody = StringIO.new()
        sftp.download!(File.join(path, filename), filebody)
        files << FtpFile.new(filename, filebody)
      end
    end
    return files
  end
  
  def self.remove_files(path, files)
    Net::SFTP.start(@@ftp_settings[:host], @@ftp_settings[:username], :port => @@ftp_settings[:port], :password => @@ftp_settings[:password]) do |sftp|
      files.each do | file |
        sftp.remove!(File.join(path, file.Name))
        yield file if block_given?
      end
    end
  end

end
