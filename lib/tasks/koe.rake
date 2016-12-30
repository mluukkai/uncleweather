task :koe => :environment do
  puts Rails.logger.class
  Rails.logger = Logger.new(STDOUT)
  puts "TEST\n"*10
end
