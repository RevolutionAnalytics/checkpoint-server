#!/usr/bin/python
 
import urllib
import smtplib
from email.mime.text import MIMEText
from time import strftime, gmtime
 
date = strftime("%Y-%m-%d", gmtime())
url_result = urllib.urlopen("http://mran.revolutionanalytics.com/snapshot/" + date + "/index.html").getcode()
 
if url_result == 200:
    print "Success! Todays snapshot is present on MRAN!"
else:
    msg = MIMEText("Whoa! Todays MRAN snapshot is missing!")
    msg['Subject'] = 'MRAN Snapshot Monitor'
    msg['From'] = 'mran-monitor@revolutionanalytics.com'
    msg['To'] = 'chris.mosetick@revolutionanalytics.com'
 
    s = smtplib.SMTP('localhost')
    s.sendmail('mran-monitor@revolutionanalytics.com', ['chris.mosetick@revolutionanalytics.com'], msg.as_string())
    s.quit()
