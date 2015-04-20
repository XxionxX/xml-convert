#!/usr/bin/env ruby
require 'xslt'
require 'optparse'

counter = 0

# Hash for options
options = {}

# Pass the new option hashes to optparse to be parsed
optparse = OptionParser.new do|opts|
    # Banner to display at the top of the help screen
    opts.banner = "Usage: xml-converter.rb [options] file1 file2..."

    opts.on('-p', '--path path', 'Set the filepath to the files you wish to convert') do |i|
        options[:path] = i
    end

    opts.on('-o', '--output output', 'Set the output destination filepath for the convert files') do |i|
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

# Set the filepath_flag to true if there is a specified filepath
filepath_flag = options[:path] != nil ? true : false

# Set the filepath to a non nil value if :path is nil
filepath = options[:path] != nil ? options[:path] : ''

# Set the output destination filepath to a non nil value if :output is nil
output = options[:output] != nil ? options[:output] : ''

# Set the output filename to a non nil value if :name is nil
new_filename = options[:name] != nil ? options[:name] : 'output'

# Transform each file
ARGV.each do |filename|
    if File.exists?(filepath + filename)
        # Retrieve an XSLT stylesheet to convert the xml file
        stylesheet_doc = XML::Document.file('xml-converter.xsl')
        stylesheet = XSLT::Stylesheet.new(stylesheet_doc)

        # Transform a xml document using the XSLT stylesheet
        xml_doc = XML::Document.file(filepath + filename)
        result = stylesheet.apply(xml_doc)

        # Increment the counter to output a unique filename
        counter += 1

        # Check to see if there is a specified filepath, else write to stdout
        if filepath_flag == true
            # Write library output to the specidied filepath
            fname = output + new_filename + counter.to_s + ".xml"
            somefile = File.open(fname, "w")
            somefile.puts result
            somefile.close
        else
            $stdout.puts result
        end

        # Display if verbose is set
        if options[:verbose] == true
            puts "Success!"
        end
    else
        # Display if verbose is set
        if options[:verbose] == true
            puts filename + " was not a valid filename."
        end
    end
end
