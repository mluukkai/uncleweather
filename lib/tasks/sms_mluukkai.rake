task :sms_mluukkai => :environment do
  responses = Message.to(:mluukkai)
  puts "DEBUG sms messages sent with statuscodes #{responses}"
end