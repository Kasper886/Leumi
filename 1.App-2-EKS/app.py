#!/usr/bin/env python3
from flask import Flask
import cgi
import html
import os

app = Flask(__name__)
myip=os.popen("curl http://169.254.169.254/latest/meta-data/local-ipv4").read()
print(myip)

@app.route('/')
def hello_world():
  print("Content-type: text/html\n")
  a="""<!DOCTYPE HTML>
  <html>
  <body bgcolor="black">
    <h3 align="center"><font color="gold">Build by Power of Terraform <font color="red"> v1.0.9</font></h3>
    <h2 align="center"><font color="green">
    Hello form EKS cluster!"""+myip+"""</font>
    <br/></h2>
    <p align="center"><font color="magenta">
    <b>Version 1.0</b></font><br/>
    <font color="white">
    <b>Created by Alex Largman</b></font></p>
  </body>
  </html>"""
  return a