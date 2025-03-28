#!/usr/bin/env ruby
require 'yaml'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: generate_htaccess.rb [options] file1.yml file2.yml ... OR directory"

  opts.on("-o", "--output FILE", "Fichier de sortie (.htaccess par défaut)") do |file|
    options[:output] = file
  end
  
  opts.on("-d", "--directory DIR", "Répertoire contenant les fichiers .yml") do |dir|
    options[:directory] = dir
  end
end.parse!

# Collecte des fichiers d'entrée
input_files = []

if options[:directory]
  # Si un répertoire est spécifié, collecter tous les fichiers .yml
  dir_path = options[:directory]
  if Dir.exist?(dir_path)
    input_files = Dir.glob(File.join(dir_path, "*.yml"))
    if input_files.empty?
      puts "No .yml files found in directory: #{dir_path}"
      exit 1
    end
  else
    puts "Directory not found: #{dir_path}"
    exit 1
  end
else
  # Sinon utiliser les arguments comme fichiers individuels
  input_files = ARGV
  if input_files.empty?
    puts "No input files specified."
    puts "Usage: generate_htaccess.rb [options] file1.yml file2.yml ... OR --directory DIR"
    exit 1
  end
end

output_file = options[:output] || '.htaccess'
lines = [
  "RedirectMatch ^(/[^/]+)/(VAC[0-9]+)/ePIL/(.*)  $1/$2/1/ePIL/$3",
  "RedirectMatch ^(/[^/]+)/(VAC[0-9]+)/SmPC/(.*)  $1/$2/1/SmPC/$3",
  ""
]

input_files.each do |input_file|
  begin
    data = YAML.load_file(input_file)
  rescue StandardError => e
    puts "Error reading file #{input_file}: #{e.message}"
    next
  end

  prefix = File.basename(input_file, File.extname(input_file))

  data.each do |vac_code, details|
    details.each do |doc_index, values|
      values.each do |doc_type, i18n|
        next if doc_type == "label"
        i18n.each do |lang, url|
          lines << "Redirect 302 \"/#{prefix}/#{vac_code}/#{doc_index}/#{doc_type}/#{lang}\" \"#{url}\""
        end
      end
    end
  end
end

begin
  File.open(output_file, 'w') do |file|
    file.puts lines.join("\n")
  end
  puts "File #{output_file} generated successfully."
rescue StandardError => e
  puts "Error writing file #{output_file}: #{e.message}"
  exit 1
end
