# frozen_string_literal: true

QUERY = <<~SOQL
  SELECT
    Id,
    Firstname,
    Lastname,
    Birthdate
  FROM Contact LIMIT 5000
SOQL

def select_contacts
  # Salesforce.query("SELECT Id, Firstname, Lastname, Birthdate FROM Contact WHERE Id = '0032400000Kl9W7AAJ'")
  Salesforce.query(QUERY)
end
