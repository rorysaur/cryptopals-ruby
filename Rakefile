task default: %w(test)

task :test do
  Dir.foreach("./test") do |filename|
    excluded_filenames = %w(. ..)
    next if excluded_filenames.include?(filename)

    require "./test/#{filename}"
  end
end
