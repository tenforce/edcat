require 'nokogiri'

def valid_plugin?(plugin)
  !plugin.nil? &&
    !plugin.css('plugin name').nil? && 
    !plugin.css('plugin groupId').first.nil? &&
    !plugin.css('plugin artifactId').first.nil? &&
    !plugin.css('plugin version').first.nil?
end

pom_file = 'base/core/pom.xml'
plugin_file = 'plugin.xml'

pom = Nokogiri::XML::Document.parse(File.read(pom_file))
dependencies = pom.css('dependencies').first

plugins = Dir.entries(".").find_all { |x| File.directory?(x) && x.end_with?("plugin") }
plugins.each do |plugin_folder|
  plugin = Nokogiri::XML::Document.parse(File.read("#{plugin_folder}/#{plugin_file}")) rescue nil
  unless valid_plugin? plugin
    puts ""
    puts "XML of #{plugin_folder} is missing or invalid. Ignoring this plugin."
    next
  end

  name = plugin.css('plugin name').text
  description = plugin.css('plugin description').text
  puts ""
  puts "#########{'#'*name.size}"
  puts "Plugin: #{name}"
  puts "#########{'#'*name.size}"
  puts "Description: #{description}"
  puts ""
  print "Do you want to include '#{name}'? (Y/N) "
  answer = gets.chomp.downcase
  
  until ["y", "n"].include? answer
    print "Answer must be Y/N! Do you want to include #{name}? (Y/N) "
    answer = gets.chomp.downcase
  end
  
  if answer == "y"
    dependency = pom.create_element('dependency')
    dependencies.add_child(dependency)
    dependency.add_child(plugin.css('plugin groupId').first)
    dependency.add_child(plugin.css('plugin artifactId').first)
    dependency.add_child(plugin.css('plugin version').first)
  end

end

pom.write_xml_to(File.open(pom_file, 'w'))
puts ""
puts "POM file with the selected plugins has been generated. You can start using your EDCAT now!"
