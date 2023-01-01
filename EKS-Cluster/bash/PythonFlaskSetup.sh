#---------------------------------#
# Install Python3, pip and Flask  #
#                                 #
# Created 08.11.2021              #
# Owner: Alex Largman             # 
# email: Alex@Largman.pro         #
#---------------------------------#
#!/bin/bash
sudo apt update
sudo apt -y install python3.9
sudo apt -y install python3-pip
pip3 install Flask
pip3 freeze | grep Flask >> requirements.txt