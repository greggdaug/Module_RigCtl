#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 3 2019

ICOM IC-7100 set ptt lock from CI-V

Command structure = FE FE 88 E0 1A 05 00 14 xx FD (xx 00=0ff, 01=on)
Return structure = FE FE 88 E0 1A 05 00 14 FE FE E0 88 1A 05 00 14 xx FD (xx, 00=off, 01=on)

@author: Gregg Daugherty (WB6YAZ)
"""

import serial

ser = serial.Serial('/dev/ttyUSB0',baudrate=9600,timeout=0.5)

# print(ser.isOpen())

ser.flushInput()
ser.flushOutput()

data = b'\xFE\xFE\x88\xE0\x1A\x05\x00\x14\x01\xFD' # set ptt lock on

ser.write(data)

# print(data)

#s = ser.read_until('')
# print(s)

#pttlock = []
#for i in range (0,15):
  #pttlock.append(hex(s[i])[2:])
  #print(pttlock)

#if pttlock[14]=='fb':
  #print('CMD OK')

#elif pttlock[14]=='fa':
  #print('CMD NG')

ser.close()
