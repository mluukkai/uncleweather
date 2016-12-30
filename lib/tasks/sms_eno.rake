task :sms_eno => :environment do
  #responses = Message.to(:eno)
  responses = Message.to(:mluukkai)
  puts "DEBUG sms messages sent with statuscodes #{responses}"
end
