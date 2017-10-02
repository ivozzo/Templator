QUERY_EDIT_TOKEN = "api.php?format=xml&action=query&meta=tokens"
QUERY_LOGIN = "api.php?format=xml&?action=login&lgname=username&lgpassword=userpassword"

module Tokenizer

    def self.queryEditToken(options)
        queryEditUri = options.mediawiki + QUERY_EDIT_TOKEN
        uri = URI.parse(queryEditUri)

        puts "Requesting edit token from #{uri} without authentication first..."
        response = Net::HTTP.get_response(uri)

        parsedResponse = Nokogiri::HTML::parse response.body
        parsed_string = parsedResponse.xpath('//error/@code')

        if parsed_string.to_s == "readapidenied"
            puts "Got an error, retrieving login token now..."
            queryLoginToken(options)
        end

        response
    end

    def self.queryLoginToken(options)
        queryLoginUri = options.mediawiki + QUERY_LOGIN
        queryLoginUri.sub! 'username', options.login
        queryLoginUri.sub! 'userpassword', options.password
        uri = URI.parse(queryLoginUri)

        response = Net::HTTP.post_form(uri, {"lgname" => options.login, "lgpassword" => options.password})
        parsedResponse = Nokogiri::HTML::parse response.body

        puts parsedResponse
    end

end