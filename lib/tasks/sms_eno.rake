task :sms_eno => :environment do
  responses = Message.to(:eno)
  puts "DEBUG sms messages sent with statuscodes #{responses}"
end
