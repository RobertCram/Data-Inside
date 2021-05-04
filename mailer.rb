# frozen_string_literal: true

require 'mail'

# Used for sending mail
class Mailer
  def self.defaults
    Mail.defaults do
      delivery_method :smtp,
                      address: 'smtp.gmail.com',
                      port: 587,
                      domain: 'gmail.com',
                      user_name: Chamber.env['development']['smtp_username'],
                      password: Chamber.env['development']['smtp_password'],
                      authentication: :plain,
                      enable_ssl: true
    end
  end

  def self.deliver(to, subject, body)
    Mail.deliver do
      from 'robert.cram@gmail.com'
      to to
      subject subject
      body body
    end
  end

  def self.sendmail(to, subject, body)
    defaults
    deliver(to, subject, body)
  end
end
