require 'chamber'
require 'yaml'
require_relative 'notifier'
require_relative 'salesforce'
require_relative 'ftp'

class FileExchanger

  def initialize
    Ftp.ftp_settings (
    {      
      host: ENV['FTP_HOST'] || Chamber['development'][:ftp_host],
      port: ENV['FTP_PORT'] || Chamber['development'][:ftp_port],
      username: ENV['FTP_USERNAME'] || Chamber['development'][:ftp_username],
      password: ENV['FTP_PASSWORD'] || Chamber['development'][:ftp_password],
    })
  end

  def sendFiles
    started = timestr
    $christal_info = { started: started, stopped: '', error: '' }
    puts "Incassobestanden klaarzetten is gestart: #{started}"

    elapsed = Benchmark.measure { 
      documents = Salesforce.query("SELECT Id, Name, Body FROM Document WHERE Name LIKE 'incassocontracten%'" )
      puts documents

      Ftp.upload_files "FTP Shared Wilde Ganzen/Christal", documents do | document |
        puts 'Verstuurd - ' + document.Name
        Salesforce.upsert!(document, :Name => 'Verstuurd - ' + document.Name)  
      end
    }

    stopped = timestr
    $christal_info[:stopped] = stopped
    puts "Incassobestanden klaarzetten in gestopt: #{stopped}\nTotaal verstreken tijd: #{seconds_to_hms(elapsed.real.to_i)}\n\n"

  rescue StandardError => e
    $christal_info[:stopped] = timestr
    $christal_info[:error] = e.message
    subject = "[Christal Server] #{e}"
    body = "incassobestanden klaarzetten is mislukt.\n\n#{e.inspect}"
    Notifier.sendmail(subject, body)
      
    puts "Incassobestanden klaarzetten is beëindigd met fouten: #{timestr}\n\n#{e.inspect}\n\n"  
  end
    
end
