% send_zero()
function send_zero()
    chatpub=rospublisher('/chatter','std_msgs/Int16','IsLatching',true);
    msg=rosmessage(chatpub);
    msg.Data=0;
    send(chatpub,msg);
    sub1=rossubscriber('/chatter');
    fb1=receive(sub1);   %checking subscriber.fb=>feedback
    fb1=fb1.Data;
    while fb1 ~= 0
        msg=rosmessage(chatpub);
        msg.Data=0;
        send(chatpub,msg);
        sub1=rossubscriber('/chatter');
        fb1=receive(sub1);   %checking subscriber.fb=>feedback
        fb1=fb1.Data;
    end
return