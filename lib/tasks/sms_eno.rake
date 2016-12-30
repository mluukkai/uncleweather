task :sms_eno => :environment do
  responses = Message.to(:mluukkai)
  puts responses
end
