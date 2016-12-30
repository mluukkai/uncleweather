task :sms_eno => :environment do
  responses = Message.to(:eno)
  puts responses
end
