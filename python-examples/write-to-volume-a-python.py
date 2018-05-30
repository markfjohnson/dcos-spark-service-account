import os

print("hello world")
file = open("testfile.txt","w")

#file.write("Operating System: {}".format(os.uname()))
file.write("Current working directory: {}\r\n".format(os.getcwd()))

file.write("Get current user name: {}\r\n".format(os.system('whoami')))
#file.write("Get current process id: {}".format(os.getuid()))
#file.write("Real process id: {}".format(os.getgid()))