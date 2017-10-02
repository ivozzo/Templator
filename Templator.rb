require 'optparse'
require 'mediawiki_api'

def load_library(pth)
    require File.join(File.expand_path(File.dirname(__FILE__)), pth)
end

load_library('Lib/Mediawiki.rb')

Options = Struct.new(:help, :mediawiki, :login, :password)

# Parse arguments
def parse_args(args)
    options = Options.new
    parser = OptionParser.new do |p|
        p.banner = 'Usage: Templator.rb [options]'

        p.on('--mediawiki URL', 'Mediawiki url (i.e. http://www.fakewiki.com/fake/)') do |mediawiki|
            options.mediawiki = mediawiki
        end
        p.on('--login LOGIN', 'Mediawiki login username') do |login|
            options.login = login
        end
        p.on('--password PASSWORD', 'Mediawiki login password') do |password|
            options.password = password
        end
        p.on('--help', 'Print this help.') do |help|
            options.help = true
        end
    end

    begin
        parser.parse!
    rescue => exc
        puts exc
        puts parser.help
        exit -1
    end

    p options

    if options.help
        puts parser
        exit
    end

    if ([options.mediawiki].any?(&:nil?))
        puts 'Missing some required options, please see help (--help)'
        puts parser.help
        exit -2
    end

    options
end

# Define the main flow
def main(argv)
    options = parse_args(argv)

    mediawikiClient = Mediawiki.getClient(options.mediawiki)
    Mediawiki.login(mediawikiClient, options.login, options.password)

    templateList = Dir["Templates/**"]

    templateList.each do |template|
        content = ""
        templateFile = File.open(template, "r")
        templateFile.each_line do |line|
            content << line
        end
        templateFile.close

        template.sub! "Templates/", ""
        template.sub! ".txt", ""
        Mediawiki.editPage(mediawikiClient, template, content)
    end

end
  
# Launch Templator
main(ARGV)