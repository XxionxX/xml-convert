#require 'rubygems'
#require 'bundler/setup'
require 'xslt'

choice = 'y'

while choice != 'n'
    puts "What file would you like to convert?"
    print "Filename: "
    filename = gets.chomp


    if File.exists?(filename)
        # Create a new XSL Transform
        stylesheet_doc = XML::Document.file('test.xsl')
        stylesheet = XSLT::Stylesheet.new(stylesheet_doc)

        # Transform a xml document
        xml_doc = XML::Document.file(filename)
        result = stylesheet.apply(xml_doc)

        fname = "test.html"
        somefile = File.open(fname, "w")
        somefile.puts result
        somefile.close
    else
        puts "That was not a valid filename."
    end

    puts "Would you like to convert another file?"
    print "(y)es or (n)o?: "
    choice = gets.chomp
end