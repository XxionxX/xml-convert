#!/usr/bin/env ruby
require 'xslt'
require 'optparse'

counter = 0

# Hash for options
options = {}

optparse = OptionParser.new do|opts|
    # Banner to display at the top of the help screen
    opts.banner = "Usage: xml-converter.rb [options] file1 file2..."

    opts.on('-p', '--path path', 'Set the filepath') do |i|
        options[:path] = i
    end

    opts.on('-o', '--output output', 'Set the output destination filepath for the transformed files') do |i|
        options[:output] = i
    end

    opts.on('-f', '--filename name', 'Set the output filename') do |i|
        options[:name] = i
    end

    options[:verbose] = false
    opts.on( '-v', '--verbose', 'Output more information' ) do
        options[:verbose] = true
    end

    opts.on('-h', '--help', 'Display help screen') do
        puts opts
        exit
    end
end

optparse.parse!

# Set the filepath to a non nil value
options[:path] != nil ? filepath = options[:path] : filepath = ''

# Set the output filepath to a non nil value
options[:output] != nil ? output = options[:output] : output = ''

# Set the output filepath to a non nil value
options[:name] != nil ? new_filename = options[:name] : new_filename = 'output'

# Transform each file
ARGV.each do |filename|
    if File.exists?(filepath + filename)
        # Retrieve an XSLT stylesheet to transform the xml file
        stylesheet_doc = XML::Document.file('xml-converter.xsl')
        stylesheet = XSLT::Stylesheet.new(stylesheet_doc)

        # Transform a xml document using the XSLT stylesheet
        xml_doc = XML::Document.file(filepath + filename)
        result = stylesheet.apply(xml_doc)

        # Increment the counter to output a unique filename
        counter += 1

        # Write the output to a file
        fname = output + new_filename + counter.to_s + ".xml"
        somefile = File.open(fname, "w")
        somefile.puts result
        somefile.close

        # Display verbose
        if options[:verbose] == true
            puts "Success!"
        end
    else
        # Display verbose
        if options[:verbose] == true
            puts filename + " was not a valid filename."
        end
    end
end
