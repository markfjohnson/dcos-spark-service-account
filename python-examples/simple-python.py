import os

print("hello world")

print ("Operating System: {}".format(os.uname()))
print ("Current working directory: {}".format(os.getcwd()))
print ("Get current user name: {}".format(os.system('whoami')))
#print ("Get current process id: {}".format(os.getuid))
print ("Real process id: {}".format(os.getpgid()))
