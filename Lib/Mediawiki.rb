API_PATH = "api.php"

module Mediawiki

    def self.getClient(mediawikiUri)
        mediawikiUri << API_PATH
        puts "Creating new client for #{mediawikiUri}..."
        mediawikiClient = MediawikiApi::Client.new mediawikiUri

        mediawikiClient
    end

    def self.editPage(mediawikiClient, pageTitle, pageContent)
        puts "Creating/updating page [Title: #{pageTitle}]..."
        mediawikiClient.create_page pageTitle, pageContent
    end

    def self.login(mediawikiClient, login, password)
        puts "Logging in as user: #{login}..."
        mediawikiClient.log_in login, password
    end

end