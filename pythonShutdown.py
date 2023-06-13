#!/usr/bin/python3

# A Video Looper for the Raspberry Pi 4
#
# author:  Jon Witts
# license: GPL-3.0, see LICENSE included in this package
#
# A Bash Video Looper for the Raspberry Pi 4 and a Python3 shutdown button and LED indicator
# https://github.com/jonwitts/pi_vid_looper_VLC

from gpiozero import Button, LED
from signal import pause
from time import sleep
from os import system

button = Button(17, hold_time=3)
led = LED(16)

def shutdown_pi():
    for i in range(3):
        led.on()
        sleep(0.5)
        led.off()
        sleep(0.5)
    system("sudo shutdown now -hP")

button.when_held = shutdown_pi
pause()
