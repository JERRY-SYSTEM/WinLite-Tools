#coding:utf-8
from cProfile import label
from email.mime import image
from genericpath import isfile
from textwrap import fill
import time
import tkinter as tk
import os
import sys
from tkinter import HORIZONTAL, N, SUNKEN, Label, PhotoImage, Widget, filedialog
from tkinter import messagebox
import tkinter
from tkinter.ttk import Progressbar
import turtle as t
import ctypes
import win32con
from win32 import win32gui
import subprocess
import threading
from tkinter.ttk import *

class Help(tk.Toplevel):
'''Help'''

def __init__(self = None):
super().__init__()
self.title(' \xe5\xb8\xae \xe5\x8a\xa9'.encode('raw_unicode_escape').decode())
self.geometry('500x300+170+190')
self.resizable(False, False)
self.currdir = os.path.dirname(os.path.realpath(sys.argv[0]))
self.iconbitmap('%s\\image\\winlite.ico' % self.currdir)
self.setup_UI()


def setup_UI(self):
self.canvas = tk.Canvas(self, width=500, height=300, background='white')
self.canvas.create_text(200, 40, text='1: \xe6\x9c\xac\xe5\xb7\xa5\xe5\x85\xb7win10\xe5\x92\x8cwin11\xe9\x80\x9a\xe7\x94\xa8 '.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(200, 90, text='2: \xe4\xbd\xbf\xe7\x94\xa8WinSxS\xe4\xbc\x98\xe5\x8c\x96\xe5\x90\x8e\xe4\xb8\x8d\xe8\x83\xbd\xe6\x9b\xb4\xe6\x96\xb0 '.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(200, 140, text='3: \xe5\x85\xb6\xe4\xbd\x99\xe7\xb2\xbe\xe7\xae\x80\xe9\xa1\xb9\xe5\x9d\x87\xe4\xb8\x8d\xe5\xbd\xb1\xe5\x93\x8d\xe6\x9b\xb4\xe6\x96\xb0 '.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93')
self.canvas.create_text(200, 190, text='4: \xe7\xb2\xbe\xe7\xae\x80Defender\xe5\x92\x8cEdge\xe6\x9b\xb4\xe6\x96\xb0\xe4\xb8\x8d\xe5\x9b\x9e\xe6\xbb\x9a'.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(200, 240, text='5: \xe7\xb2\xbe\xe7\xae\x80\xe5\x90\x8e\xe8\xbf\x90\xe8\xa1\x8c\xe9\x87\x8d\xe6\x9e\x84\xe4\xbc\x98\xe5\x8c\x96\xe5\x8f\xaf\xe5\x87\x8f\xe5\xb0\x8f\xe4\xbd\x93\xe7\xa7\xaf'.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(200, 40, text='1: \xe6\x9c\xac\xe5\xb7\xa5\xe5\x85\xb7win10\xe5\x92\x8cwin11\xe9\x80\x9a\xe7\x94\xa8 '.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(200, 90, text='2: \xe4\xbd\xbf\xe7\x94\xa8WinSxS\xe4\xbc\x98\xe5\x8c\x96\xe5\x90\x8e\xe4\xb8\x8d\xe8\x83\xbd\xe6\x9b\xb4\xe6\x96\xb0 '.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(200, 140, text='3: \xe5\x85\xb6\xe4\xbd\x99\xe7\xb2\xbe\xe7\xae\x80\xe9\xa1\xb9\xe5\x9d\x87\xe4\xb8\x8d\xe5\xbd\xb1\xe5\x93\x8d\xe6\x9b\xb4\xe6\x96\xb0 '.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93')
self.canvas.create_text(200, 190, text='4: \xe7\xb2\xbe\xe7\xae\x80Defender\xe5\x92\x8cEdge\xe6\x9b\xb4\xe6\x96\xb0\xe4\xb8\x8d\xe5\x9b\x9e\xe6\xbb\x9a'.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(200, 240, text='5: \xe7\xb2\xbe\xe7\xae\x80\xe5\x90\x8e\xe8\xbf\x90\xe8\xa1\x8c\xe9\x87\x8d\xe6\x9e\x84\xe4\xbc\x98\xe5\x8c\x96\xe5\x8f\xaf\xe5\x87\x8f\xe5\xb0\x8f\xe4\xbd\x93\xe7\xa7\xaf'.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.pack()

__classcell__ = None

class About(tk.Toplevel):
'''About'''

def __init__(self = None):
super().__init__()
self.title(' \xe5\x85\xb3 \xe4\xba\x8e')
self.geometry('500x300+270+230')
self.resizable(False, False)
self.currdir = os.path.dirname(os.path.realpath(sys.argv[0]))
self.iconbitmap('%s\\image\\winlite.ico' % self.currdir)
self.setup_UI()


def setup_UI(self):
self.canvas = tk.Canvas(self, 500, 300, 'white', **('width', 'height', 'background'))
self.canvas.create_text(250, 80, ' WinLite1.2 ', '\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode(), **('text', 'font'))
self.canvas.create_text(250, 150, ' \xe9\x97\xae\xe9\xa2\x98\xe5\x8f\x8d\xe9\xa6\x88:jwfst5009@163.com'.encode('raw_unicode_escape').decode(), '\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode(), **('text', 'font'))
self.canvas.pack()

__classcell__ = None

class Regist(tk.Toplevel):
'''Regist'''

def __init__(self = None):
super().__init__()
self.title(' \xe6\x8d\x90 \xe8\xb5\xa0'.encode('raw_unicode_escape').decode())
self.geometry('500x300+370+190')
self.resizable(False, False)
self.currdir = os.path.dirname(os.path.realpath(sys.argv[0]))
self.iconbitmap('%s\\image\\winlite.ico' % self.currdir)
self.setup_UI()


def setup_UI(self):
self.canvas = tk.Canvas(self, width=500, height=300, background='pink')
self.canvas.create_text(250, 20, text='\xe6\x89\xab\xe7\xa0\x81\xe6\x8d\x90\xe8\xb5\xa0\xe7\x94\xa8\xe4\xba\x8e\xe8\xbd\xaf\xe4\xbb\xb6\xe5\xbc\x80\xe5\x8f\x91,\xe6\x9c\x80\xe5\xb0\x9110\xe5\x85\x83'.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(250, 50, text='\xe6\x8d\x90\xe8\xb5\xa0\xe5\xa4\xa7\xe4\xba\x8e50\xe5\x85\x83\xe5\xb0\x86\xe6\x98\xbe\xe7\xa4\xba\xe5\x9c\xa8\xe8\xbd\xaf\xe4\xbb\xb6\xe6\x8d\x90\xe8\xb5\xa0\xe6\xa6\x9c\xe4\xb8\x8a'.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(250, 80, text='\xe6\x84\x9f\xe8\xb0\xa2\xe6\x82\xa8\xe7\x9a\x84\xe6\x94\xaf\xe6\x8c\x81\xef\xbc\x81'.encode('raw_unicode_escape').decode(), font='\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode())
self.canvas.create_text(330, 110, text='\xe6\x8d\x90 \xe8\xb5\xa0 \xe6\xa6\x9c \xe5\x8d\x95'.encode('raw_unicode_escape').decode(), fill='red')
self.canvas.create_text(330, 130, text='\xe5\x86\xaf\xe5\x8f\x8b\xe5\x85\xb0 \xe5\x88\x98\xe9\x82\xa6\xe7\xa4\xbc \xe8\x91\xa3\xe6\xb4\x81\xe8\x90\x8c \xe7\x8e\x8b\xe5\x9b\xbd\xe6\xa0\x8b \xe5\x87\x8c\xe6\xb3\xa2\xe5\xbe\xae\xe6\xad\xa5'.encode('raw_unicode_escape').decode(), fill='red')
self.canvas.pack()
x = 100
y = 180
self.img = tk.PhotoImage(file='%s\\image\\sk.png' % self.currdir)
self.img = self.img.subsample(5)
self.canvas.create_image(x, y, image=self.img)

__classcell__ = None

class UnApp(tk.Toplevel):
'''UnApp'''

def __init__(self = None):
super().__init__()
self.title(' \xe8\xaf\xb7\xe9\x80\x89\xe6\x8b\xa9\xe5\x8d\xb8\xe8\xbd\xbdApp'.encode('raw_unicode_escape').decode())
self.geometry('600x400+250+160')
self.resizable(False, False)
self.protocol('WM_DELETE_WINDOW', self.exitUnApp)
self.frm = tk.Frame(self, width=600, height=360, bg='white')
self.frm2 = tk.Frame(self, width=596, bg='grey')
self.canvas = tk.Canvas(self.frm2, width=596, height=75, bg='white')
self.currdir = os.path.dirname(os.path.realpath(sys.argv[0]))
self.iconbitmap('%s\\image\\winlite.ico' % self.currdir)
self.drv = self.currdir[:1]
self.temp = 'C:\\Users\\Default\\AppData\\Local\\Temp'
self.mflag = False
self.str = ''
self.txt = self.canvas.create_text(260, 20, text=self.str, fill='red', font=('\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode(), 18))
self.setup_UI()


def exitUnApp(self):
self.destroy()


def probar(self, bartime):
self.A = Style()
self.A.theme_use('winnative')
self.A.configure('fp.Horizontal.TProgressbar', troughcolor='grey', background='green', lightcolor='#0078d7', darkcolor='#0078d7', relief=tk.GROOVE)
self.pbar = Progressbar(self, length=400, orient=HORIZONTAL, mode='determinate', style='fp.Horizontal.TProgressbar')
self.pbar.place(x=40, y=360)
self.pbar['value'] = 0
self.pbar['maximum'] = bartime
for i in range(bartime):
time.sleep(1)
self.pbar['value'] = i + 1
if self.mflag == True or i == self.pbar['maximum'] - 1:
self.pbar['value'] = self.pbar['maximum']
return None
self.update()
self.pbar.stop()


def tijaobar(self):
if not os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
threading.Thread(target=self.tijao, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()


def tijao(self):
self.mflag = False
self.update_idletasks()
start = time.perf_counter()
self.canvas.delete(self.txt)
subprocess.call('Dism /Image:%s:\\win10 /Get-ProvisionedAppxPackages >%s\\AppxPackages.txt' % (self.drv, self.temp), shell=True)
# WARNING: Decompyle incomplete


def mylabel(self, str):
self.txt = self.canvas.create_text(260, 20, text=self.str, fill='red', font=('\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode(), 18))


def setup_UI(self):
self.frm.pack()
self.frm2.pack()
self.canvas.pack()
self.unapps1 = {
0: '.ZuneVideo_',
1: '.YourPhone_',
2: '.ZuneMusic_',
3: '.WindowsMaps_',
4: '.WindowsFeedbackHub_',
5: '.windowscommunicationsapps_',
6: '.WindowsAlarms_',
7: '.WebMediaExtensions_',
8: '.Wallet_',
9: '.SkypeApp_',
10: '.People_',
11: '.Office.OneNote_' }
self.unapps2 = {
0: '.Getstarted_',
1: '.GetHelp_',
2: '.BingWeather_',
3: '.549981C3F5F10_',
4: '.DesktopAppInstaller_',
5: '.MicrosoftOfficeHub_',
6: '.Microsoft3DViewer_',
7: '.MicrosoftSolitaireCollection_',
8: '.MixedReality.Portal_',
9: '.MSPaint_',
10: '.ScreenSketch_',
11: '.StorePurchaseApp_' }
self.unapps3 = {
0: '.Photos_',
1: '.WindowsCalculator_',
2: '.WindowsCamera_',
3: '.WindowsSoundRecorder_',
4: '.WindowsStore_',
5: '.Xbox.TCUI_',
6: '.XboxApp_',
7: '.XboxGameOverlay_',
8: '.XboxGamingOverlay_',
9: '.XboxIdentityProvider_',
10: '.XboxSpeechToTextOverlay_',
11: '.MicrosoftStickyNotes_' }
self.checkboxs1 = { }
self.checkboxs2 = { }
self.checkboxs3 = { }
for i in range(len(self.unapps1)):
self.checkboxs1[i] = tk.BooleanVar()
tk.Checkbutton(self.frm, text=self.unapps1[i], bg='white', selectcolor='pink', variable=self.checkboxs1[i]).grid(row=i + 2, column=1, sticky='w')
for i in range(len(self.unapps2)):
self.checkboxs2[i] = tk.BooleanVar()
tk.Checkbutton(self.frm, text=self.unapps2[i], bg='white', selectcolor='pink', variable=self.checkboxs2[i]).grid(row=i + 2, column=2, sticky='w')
for i in range(len(self.unapps3)):
self.checkboxs3[i] = tk.BooleanVar()
tk.Checkbutton(self.frm, text=self.unapps3[i], bg='white', selectcolor='pink', variable=self.checkboxs3[i]).grid(row=i + 2, column=3, sticky='w')
tk.Button(self, text=' \xe6\x8f\x90 \xe4\xba\xa4 ', bg='white', command=self.tijaobar).place(x=500, y=355)

__classcell__ = None


class WinLiteMain(tk.Tk):
'''WinLiteMain'''

def __init__(self = None):
global flagUnapp
super().__init__()
flagUnapp = False
self.title(' WinLite1.2')
self.geometry('700x500+200+100')
self.resizable(False, False)
self.wm_attributes('-topmost', False)
self.protocol('WM_DELETE_WINDOW', self.exitWinLiteMain)
self.filewim = ''
self.currdir = os.path.dirname(os.path.realpath(sys.argv[0]))
self.iconbitmap('%s\\image\\winlite.ico' % self.currdir)
self.drv = self.currdir[:1]
self.temp = 'C:\\Users\\Default\\AppData\\Local\\Temp'
self.mflag = False
self.str = ''
self.frm = tk.Frame(self, width=700, height=500, bg='blue')
self.canvas = tk.Canvas(self.frm, width=700, height=500, bg='white')
self.txt = self.canvas.create_text(370, 400, text=self.str, fill='red', font=('\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode(), 28))
self.setup_UI()


def dismmount(self):
self.canvas.delete(self.txt)
start = time.perf_counter()
subprocess.call('Dism /Mount-Image /ImageFile:%s /index:1 /MountDir:%s:\\win10 2>nul' % (self.filewim, self.drv), shell=True)
self.mflag = True
self.dur = print(int(time.perf_counter() - start))
self.str = '\xe6\x8c\x82\xe8\xbd\xbd\xe6\x88\x90\xe5\x8a\x9f\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackmount(self):
self.mflag = False
self.update_idletasks()
self.canvas.delete(self.txt)
if not os.path.exists('%s:\\win10' % self.drv):
os.makedirs('%s:\\win10' % self.drv)
self.filewim = filedialog.askopenfilename(title='\xe6\x89\x93\xe5\xbc\x80wim\xe6\x96\x87\xe4\xbb\xb6'.encode('raw_unicode_escape').decode(), initialdir=os.chdir('../'), filetypes=[
('wim\xe6\x96\x87\xe4\xbb\xb6'.encode('raw_unicode_escape').decode(), '.wim')])
self.filewim = self.filewim.replace('/', '\\')
if os.listdir('%s:\\win10' % self.drv):
self.canvas.delete(self.txt)
self.str = 'win10\xe4\xb8\x8d\xe6\x98\xaf\xe9\x9d\x9e\xe7\xa9\xba\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
if os.path.exists('%s' % self.filewim):
num = 160
self.tbar = threading.Thread(target=self.probar, args=(num,))
self.tdismmount = threading.Thread(target=self.dismmount, args=())
self.tdismmount.start()
self.tbar.start()
return None


def callbackunapp(self):
unapp = UnApp()
unapp.after(50)
unapp.mainloop()


def dismexit(self):
start = time.perf_counter()
subprocess.call('Dism /unmount-wim /MountDir:%s:\\win10 /discard' % self.drv, shell=True)
subprocess.call('dism /cleanup-mountpoints', shell=True)
if not os.path.exists('%s:\\win10' % self.drv) and os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
subprocess.call('cmd.exe /c takeown /f "%s:\\win10" /r /d y && icacls "%s:\\win10" /grant administrators:F /t' % (self.drv, self.drv), shell=True)
if os.path.exists('%s:\\SOFTWAREBKP' % self.drv):
subprocess.call('del /f /q %s:\\SOFTWAREBKP' % self.drv, shell=True)
subprocess.call('RMDIR /Q /S "%s:\\win10"' % self.drv, shell=True)
if os.path.isfile('%s:\\SOFTWAREBKP' % self.drv):
subprocess.call('del %s:\\SOFTWAREBKP' % self.drv, shell=True)
if os.path.isfile('C:\\Users\\Administrator\\SOFTWAREBKP'):
subprocess.call('del C:\\Users\\Administrator\\SOFTWAREBKP', shell=True)
if os.path.isfile('C:\\Users\\SOFTWAREBKP'):
subprocess.call('del /f /q C:\\Users\\SOFTWAREBKP', shell=True)
if os.path.isfile('%s\\SOFTWAREBKP' % self.currdir):
subprocess.call('del /f /q %s\\SOFTWAREBKP' % self.currdir, shell=True)
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /f /q %s:\\SOFTWAREBKP' % (self.currdir, self.filewim[:1]), shell=True)
self.mflag = True
self.str = '\xe6\xb8\x85\xe7\x90\x86\xe5\x8d\xb8\xe8\xbd\xbd\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
print(int(time.perf_counter() - start))


def callbackexit(self):
self.mflag = False
self.update_idletasks()
self.canvas.delete(self.txt)
if os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
num = 92
self.tbar = threading.Thread(target=self.probar, args=(num,))
self.tdismexit = threading.Thread(target=self.dismexit, args=())
self.tdismexit.start()
self.tbar.start()
self.tdismexit.join()
if not os.path.exists('%s:\\win10' % self.drv) or os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
subprocess.call('cmd.exe /c takeown /f "%s:\\win10" /r /d y && icacls "%s:\\win10" /grant administrators:F /t' % (self.drv, self.drv), shell=True)
if os.path.exists('%s:\\SOFTWAREBKP' % self.drv):
subprocess.call('del /f /q %s:\\SOFTWAREBKP' % self.drv, shell=True)
subprocess.call('RMDIR /Q /S "%s:\\win10"' % self.drv, shell=True)
return None
return None
return None
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackonedrivebar(self):
if not os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
threading.Thread(target=self.callbackonedrive, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()


def callbackonedrive(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
if os.path.isfile('%s:\\win10\\Windows\\SysWOW64\\OneDriveSetup.exe' % self.drv):
subprocess.call('%s\\install_wim_tweak.exe /p "%s:\\win10" /c Microsoft-Windows-OneDrive-Setup /r' % (self.currdir, self.drv), shell=True)
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f %s:\\win10\\Windows\\SysWOW64\\OneDriveSetup.exe' % (self.currdir, self.drv), shell=True)
if os.path.isfile('%s:\\win10\\Windows\\System32\\OneDriveSetup.exe' % self.drv):
subprocess.call('%s\\install_wim_tweak.exe /p "%s:\\win10" /c Microsoft-Windows-OneDrive-Setup /r' % (self.currdir, self.drv), shell=True)
if os.path.isfile('%s:\\win10\\Users\\Default\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\OneDrive' % self.currdir):
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f %s:\\win10\\Users\\Default\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\OneDrive' % (self.currdir, self.drv), shell=True)
if os.path.isfile('%s:\\win10\\Windows\\System32\\OneDriveSettingSyncProvider.dll' % self.drv):
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f %s:\\win10\\Windows\\System32\\OneDriveSettingSyncProvider.dll' % (self.currdir, self.drv), shell=True)
if os.path.isfile('%s:\\win10\\Windows\\SysWOW64\\OneDriveSettingSyncProvider.dll' % self.drv):
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f %s:\\win10\\Windows\\SysWOW64\\OneDriveSettingSyncProvider.dll' % (self.currdir, self.drv), shell=True)
if os.path.isfile('%s:\\win10\\Windows\\SysWOW64\\OneDriveSetup.exe' % self.drv):
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f %s:\\win10\\Windows\\SysWOW64\\OneDriveSetup.exe' % (self.currdir, self.drv), shell=True)
subprocess.call('reg load HKLM\\SOFT "%s:\\win10\\Users\\Default\\NTUSER.DAT"' % self.drv, shell=True)
subprocess.call('Reg delete "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run" /v "OneDriveSetup" /f >nul 2>&1', shell=True)
subprocess.call('reg unload HKLM\\SOFT', shell=True)
self.winsxsonedrivelb1 = []
self.winsxsonedrivelb2 = os.listdir('%s:\\win10\\Windows\\WinSxS' % self.drv)
for line in self.winsxsonedrivelb2:
if '-onedrive-setup_' in line:
self.winsxsonedrivelb1.append(line)
for i in self.winsxsonedrivelb1:
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c RMDIR /S /Q "%s:\\win10\\Windows\\WinSxS\\%s"' % (self.currdir, self.drv, i), shell=True)
self.catrootlb2 = os.listdir('%s:\\win10\\Windows\\System32\\CatRoot\\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}' % self.drv)
for line in self.catrootlb2:
if 'Microsoft-Windows-OneDrive-' in line:
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f "%s:\\win10\\Windows\\System32\\CatRoot\\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\\%s"' % (self.currdir, self.drv, line), shell=True)
self.PolicyDefinitionslb2 = os.listdir('%s:\\win10\\Windows\\PolicyDefinitions' % self.drv)
for line in self.PolicyDefinitionslb2:
if 'SkyDrive.admx' in line:
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f %s:\\win10\\Windows\\PolicyDefinitions\\%s' % (self.currdir, self.drv, line), shell=True)
self.PolicyDefinitionslb = os.listdir('%s:\\win10\\Windows\\PolicyDefinitions\\zh-CN' % self.drv)
for line in self.PolicyDefinitionslb:
if 'SkyDrive.adml' in line:
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f %s:\\win10\\Windows\\PolicyDefinitions\\zh-CN\\%s' % (self.currdir, self.drv, line), shell=True)
self.servicing = os.listdir('%s:\\win10\\Windows\\servicing\\Packages' % self.drv)
for line in self.servicing:
if 'Microsoft-Windows-OneDrive-Setup-' in line:
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /q /f "%s:\\win10\\Windows\\servicing\\Packages\\%s"' % (self.currdir, self.drv, line), shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = '\xe5\x8d\xb8\xe8\xbd\xbdOneDrive\xe6\x88\x90\xe5\x8a\x9f\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def cleaupimage(self):
subprocess.call('Dism /Image:%s:\\win10 /Cleanup-Image /StartComponentCleanup &&Dism /Image:%s:\\win10 /Cleanup-Image /StartComponentCleanup /ResetBase' % (self.drv, self.drv), shell=True)


def callbackdelwdbar(self):
if not os.path.isdir('%s:\\win10\\Program Files\\Windows Defender' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
self.tbar = threading.Thread(target=self.probar, args=(num,))
self.tcallbackdelwd = threading.Thread(target=self.callbackdelwd, args=())
self.tcallbackdelwd.start()
self.tbar.start()


def callbackdelwd(self):
self.mflag = False
self.update_idletasks()
start = time.perf_counter()
self.canvas.delete(self.txt)
subprocess.call('REG LOAD HKLM\\SOFT "%s:\\win10\\Windows\\System32\\config\\SOFTWARE"' % self.drv, shell=True)
subprocess.call('reg delete "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Run" /v "SecurityHealth" /f >nul 2>&1', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender Security Center\\Systray" /v "HideSystray" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\ReserveManager" /v "ShippedWithReserves" /d 0 /t REG_DWORD /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:windowsdefender" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Security Center\\Feature" /v "DisableAvCheck" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Windows Defender Security Center\\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Windows Defender Security Center\\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Windows Defender\\Features" /v "TamperProtectionSource" /t REG_DWORD /d "2" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Windows Defender\\Signature Updates" /v "FirstAuGracePeriod" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Windows Defender\\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\StartupApproved\\Run" /v "SecurityHealth" /t REG_BINARY /d "030000000000000000000000" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender" /v "RandomizeScheduleTaskTimes" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Exclusions" /v "DisableAutoExclusions" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Quarantine" /v "LocalSettingOverridePurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Quarantine" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Real-Time Protection" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Real-Time Protection" /v "DisableScriptScanning" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Remediation" /v "Scan_ScheduleDay" /t REG_DWORD /d "8" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Remediation" /v "Scan_ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Reporting" /v "AdditionalActionTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Reporting" /v "CriticalFailureTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d 1 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Reporting" /v "NonCriticalTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "AvgCPULoadFactor" /t REG_DWORD /d "10" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "DisableArchiveScanning" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "DisableCatchupFullScan" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "DisableCatchupQuickScan" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "DisableRemovableDriveScanning" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "DisableRestorePoint" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "DisableScanningMappedNetworkDrivesForFullScan" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "DisableScanningNetworkFiles" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "PurgeItemsAfterDelay" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "ScanOnlyIfIdle" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "ScanParameters" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Scan" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Signature Updates" /v "DisableUpdateOnStartupWithoutEngine" /t REG_DWORD /d 1 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Signature Updates" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Signature Updates" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Signature Updates" /v "SignatureUpdateCatchupInterval" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d 0 /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Spynet" /v "SpyNetReporting" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Spynet" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows Defender\\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1', shell=True)
subprocess.call('reg unload HKLM\\SOFT', shell=True)
subprocess.call('REG LOAD HKLM\\SOFT "%s:\\win10\\Windows\\System32\\config\\SYSTEM"' % self.drv, shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Services\\SecurityHealthService" /v "Start" /t REG_DWORD /d 4 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Services\\wscsvc" /v "Start" /t REG_DWORD /d 4 /f >nul', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\EventLog\\System\\Microsoft-Antimalware-ShieldProvider" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\EventLog\\System\\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\MsSecFlt" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\Sense" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\WdBoot" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\WdFilter" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\WdNisDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Services\\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Control\\WMI\\Autologger\\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('Reg add "HKLM\\SOFT\\ControlSet001\\Control\\WMI\\Autologger\\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1', shell=True)
subprocess.call('reg unload HKLM\\SOFT', shell=True)
subprocess.call('dir /b "%s:\\win10\\Windows\\servicing\\Packages\\*.mum" >%s\\Get1_Full_Packages.txt' % (self.drv, self.temp), shell=True)
subprocess.call('findstr /I /V "en-us zh-tw zh-cn" %s\\Get1_Full_Packages.txt >%s\\Get2_Main_Packages.txt' % (self.temp, self.temp), shell=True)
subprocess.call('findstr /I "Windows-Defender" %s\\Get2_Main_Packages.txt >%s\\Get3_Full_Packages.txt' % (self.temp, self.temp), shell=True)
self.wdlb1 = []
with open('%s\\Get3_Full_Packages.txt' % self.temp) as f:
for line in f.readlines():
newline = line.strip()[:-4]
self.wdlb1.append(newline)

# WARNING: Decompyle incomplete


def callbackgenlitebar(self):
if not os.path.isfile('%s:\\win10\\Windows\\System32\\Recovery\\Winre.wim' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
self.tbar = threading.Thread(target=self.probar, args=(num,))
self.tcallbackgenlite = threading.Thread(target=self.callbackgenlite, args=())
self.tcallbackgenlite.start()
self.tbar.start()


def callbackgenlite(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
self.assemblylb1 = []
self.assemblylb2 = os.listdir('%s:\\win10\\Windows\\assembly' % self.drv)
for line in self.assemblylb2:
if 'NativeImages_' in line:
self.assemblylb1.append(line)
for i in self.assemblylb1:
if '_64' in i:
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c RMDIR /S /Q "%s:\\win10\\Windows\\assembly\\%s' % (self.currdir, self.drv, i), shell=True)
for i in self.assemblylb1:
if '_32' in i:
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c RMDIR /S /Q "%s:\\win10\\Windows\\assembly\\%s' % (self.currdir, self.drv, i), shell=True)
self.retaildemolb = []
subprocess.call('dir /b /a:d /s %s:\\win10 >%s\\retaildemo.txt' % (self.drv, self.temp), shell=True)
subprocess.call('find /i "RetailDemo" %s\\retaildemo.txt >%s\\retaildemo2.txt' % (self.temp, self.temp), shell=True)
with open('%s\\retaildemo2.txt' % self.temp) as f:
for i in f.readlines():
i = i.strip()
self.retaildemolb.append(i)

# WARNING: Decompyle incomplete


def callbackedgebar(self):
if not os.path.isdir('%s:\\win10\\Windows\\SystemApps\\Microsoft.MicrosoftEdge_8wekyb3d8bbwe' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
threading.Thread(target=self.callbackedge, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()


def callbackedge(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
subprocess.call('%s\\install_wim_tweak.exe /p "%s:\\win10" /c Microsoft-Windows-Internet-Browser /r' % (self.currdir, self.drv), shell=True)
subprocess.call('cmd.exe /c takeown /f "%s:\\win10\\Windows\\SystemApps\\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" /r /d y && icacls "%s:\\win10\\Windows\\SystemApps\\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" /grant administrators:F /t&RD /Q /S "%s:\\win10\\Windows\\SystemApps\\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe"' % (self.drv, self.drv, self.drv), shell=True)
subprocess.call('cmd.exe /c takeown /f "%s:\\win10\\Windows\\SystemApps\\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /r /d y && icacls "%s:\\win10\\Windows\\SystemApps\\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /grant administrators:F /t&RD /Q /S "%s:\\win10\\Windows\\SystemApps\\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"' % (self.drv, self.drv, self.drv), shell=True)
subprocess.call('cmd.exe /c takeown /f "%s:\\win10\\Program Files (x86)\\Microsoft" /r /d y && icacls "%s:\\win10\\Program Files (x86)\\Microsoft" /grant administrators:F /t&RD /Q /S "%s:\\win10\\Program Files (x86)\\Microsoft"' % (self.drv, self.drv, self.drv), shell=True)
subprocess.call('md "%s:\\win10\\Program Files (x86)\\Microsoft\\EdgeUpdate\\Install"&echo Y|cacls "%s:\\win10\\Program Files (x86)\\Microsoft\\EdgeUpdate\\Install" /P everyone:N >nul' % (self.drv, self.drv), shell=True)
subprocess.call('md "%s:\\win10\\Program Files (x86)\\Microsoft\\Edge"&echo Y|cacls "%s:\\win10\\Program Files (x86)\\Microsoft\\Edge" /P everyone:N >nul' % (self.drv, self.drv), shell=True)
subprocess.call('copy /y "%s\\windows\\UninstallEdge.exe.lnk" "%s:\\win10\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp\\" >nul 2>nul' % (self.currdir, self.drv), shell=True)
subprocess.call('copy /y "%s\\windows\\UninstallEdge.exe" "%s:\\win10\\Windows\\" >nul 2>nul' % (self.currdir, self.drv), shell=True)
subprocess.call('reg load HKLM\\SOFT "%s:\\win10\\Windows\\System32\\config\\software"' % self.drv, shell=True)
subprocess.call('reg query "HKLM\\SOFT" /s /f "MicrosoftEdge" /k >%s\\micedge.txt' % self.temp, shell=True)
self.edgelb0 = []
with open('%s\\micedge.txt' % self.temp) as f:
for line in f.readlines():
newline = line.strip()
self.edgelb0.append(newline)

# WARNING: Decompyle incomplete


def callbackoptbar(self):
if not os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe6\x96\x87\xe4\xbb\xb6\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
threading.Thread(target=self.callbackopt, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()


def callbackopt(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
subprocess.call('REG LOAD HKLM\\SOFT "%s:\\win10\\Windows\\System32\\config\\SOFTWARE"' % self.drv, shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{0ddd015d-b06c-45d5-8c4c-f59713854639}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{0ddd015d-b06c-45d5-8c4c-f59713854639}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{a0c69a99-21c8-4671-8703-7934162fcf1d}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{a0c69a99-21c8-4671-8703-7934162fcf1d}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FolderDescriptions\\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f >nul 2>nul', shell=True)
subprocess.call('reg unload HKLM\\SOFT', shell=True)
subprocess.call('REG LOAD HKLM\\SOFT "%s:\\win10\\Windows\\System32\\config\\SOFTWARE"' % self.drv, shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Command Processor" /v "CompletionChar" /t REG_DWORD /d 64 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\Windows Error Reporting\\Assert Filtering Policy" /v "ReportAndContinue" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\Windows Error Reporting\\Assert Filtering Policy" /v "AlwaysUnloadDll" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\Windows Error Reporting\\Assert Filtering Policy" /v "Max Cached Icons" /t REG_SZ /d "7500" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\SQMClient\\Windows" /v "CEIPEnable" /d 0 /t REG_DWORD /f >nul 2>nul ', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\Explorer" /v "NoUseStoreOpenWith" /t reg_dword /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\CloudContent" /v "DisableWindowsConsumerFeatures" /t reg_dword /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" /f /v "AUOptions" /t REG_DWORD /d 1', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\WOW6432Node\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" /f /v "NoAutoUpdate" /t REG_DWORD /d 1', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" /f /v "AUOptions" /t REG_DWORD /d 1', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" /f /v "NoAutoUpdate" /t REG_DWORD /d 1', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Icons" /v 77 /d "%systemroot%\\system32\\imageres.dll,197" /t reg_sz /f >nul 2>nul ', shell=True)
subprocess.call('reg delete "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Run" /f /v "SecurityHealth" >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer" /v "SmartScreenEnabled" /d off /t REG_SZ /f', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" /v "ConsentPromptBehaviorAdmin" /d 0 /t REG_DWORD /f', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\HideDesktopIcons\\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /d 0 /t REG_DWORD /f', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\HideDesktopIcons\\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /d 1 /t REG_DWORD /f', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" /v "AUOptions" /d 1 /t REG_DWORD /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" /v "AutoInstallMinorUpdates" /d 1 /t REG_DWORD /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" /v "NoAutoUpdate" /d 1 /t REG_DWORD /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Icons" /v 29 /d "%systemroot%\\system32\\imageres.dll,197" /t reg_sz /f', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Policies\\Associations" /v "ModRiskFileTypes" /d ".bat;.exe;.reg;.vbs;.chm;.msi;.js;.cmd" /t REG_SZ /f', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" /v "NoDriveTypeAutoRun" /d 255 /t REG_DWORD /f >nul 2>nul', shell=True)
subprocess.call('reg delete "HKLM\\SOFT\\Classes\\batfile\\shellex\\ContextMenuHandlers\\Compatibility" /f >nul 2>nul', shell=True)
subprocess.call('reg delete "HKLM\\SOFT\\Classes\\cmdfile\\shellex\\ContextMenuHandlers\\Compatibility" /f >nul 2>nul', shell=True)
subprocess.call('reg delete "HKLM\\SOFT\\Classes\\exefile\\shellex\\ContextMenuHandlers\\Compatibility" /f >nul 2>nul', shell=True)
subprocess.call('reg delete "HKLM\\SOFT\\Classes\\lnkfile\\shellex\\ContextMenuHandlers\\Compatibility" /f >nul 2>nul', shell=True)
subprocess.call('reg delete "HKLM\\SOFT\\Classes\\Msi.Package\\shellex\\ContextMenuHandlers\\Compatibility" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\*\\shell\\runas" /ve /t REG_SZ /d "\xe7\xae\xa1\xe7\x90\x86\xe5\x91\x98\xe5\x8f\x96\xe5\xbe\x97\xe6\x89\x80\xe6\x9c\x89\xe6\x9d\x83" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\*\\shell\\runas" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\\System32\\imageres.dll,-79" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\*\\shell\\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\*\\shell\\runas\\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \\"%%1\\" && icacls \\"%%1\\" /grant administrators:F" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\*\\shell\\runas\\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \\"%%1\\" && icacls \\"%%1\\" /grant administrators:F" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\exefile\\shell\\runas2" /ve /t REG_SZ /d "\xe7\xae\xa1\xe7\x90\x86\xe5\x91\x98\xe5\x8f\x96\xe5\xbe\x97\xe6\x89\x80\xe6\x9c\x89\xe6\x9d\x83" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\exefile\\shell\\runas2" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\\System32\\imageres.dll,-79" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\exefile\\shell\\runas2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\exefile\\shell\\runas2\\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \\"%%1\\" && icacls \\"%%1\\" /grant administrators:F" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\exefile\\shell\\runas2\\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \\"%%1\\" && icacls \\"%%1\\" /grant administrators:F" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\Directory\\shell\\runas" /ve /t REG_SZ /d "\xe7\xae\xa1\xe7\x90\x86\xe5\x91\x98\xe5\x8f\x96\xe5\xbe\x97\xe6\x89\x80\xe6\x9c\x89\xe6\x9d\x83" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\Directory\\shell\\runas" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\\System32\\imageres.dll,-79" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\Directory\\shell\\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\Directory\\shell\\runas\\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \\"%%1\\" /r /d y && icacls \\"%%1\\" /grant administrators:F /t" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Classes\\Directory\\shell\\runas\\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \\"%%1\\" /r /d y && icacls \\"%%1\\" /grant administrators:F /t" /f >nul', shell=True)
subprocess.call('reg unload HKLM\\SOFT', shell=True)
subprocess.call('REG LOAD HKLM\\SOFT "%s:\\win10\\Windows\\System32\\config\\SYSTEM"' % self.drv, shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Control\\SecurePipeServers\\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Control\\Session Manager\\Power" /f /v "HiberbootEnabled" /t REG_DWORD /d 1 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Control\\Power" /f /v "HibernateEnabled" /t REG_DWORD /d 1 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Services\\WerSvc" /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Services\\DPS" /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Services\\WdiServiceHost" /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Services\\WdiSystemHost" /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Services\\diagnosticshub.standardcollector.service" /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\ControlSet001\\Services\\DialogBlockingService" /f /v "Start" /t REG_DWORD /d 4 >nul 2>nul', shell=True)
subprocess.call('reg unload HKLM\\SOFT', shell=True)
subprocess.call('REG LOAD HKLM\\SOFT "%s:\\win10\\Users\\Default\\NTUSER.DAT"' % self.drv, shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" /v "NoDriveTypeAutoRun" /d 255 /t REG_DWORD /f >nul 2>nul ', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\AutoplayHandlers" /v "DisableAutoplay" /t reg_dword /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager" /v "RotatingLockScreenEnable" /t REG_DWORD /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Associations" /v "ModRiskFileTypes" /d ".bat;.exe;.reg;.vbs;.chm;.msi;.js;.cmd" /t REG_SZ /f', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" /v "ColorPrevalence" /t reg_dword /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\DWM" /v "ColorPrevalence" /t reg_dword /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer" /v "DisableNotificationCenter" /t reg_dword /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" /v "HideSCAHealth" /t reg_dword /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" /v "HideFileExt" /t reg_dword /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Notepad" /v "StatusBar" /t reg_dword /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Notepad" /v "fWrap" /t reg_dword /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\People" /v "PeopleBand" /t REG_DWORD /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 10 >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /f /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d 10 >nul 2>nul', shell=True)
subprocess.call('reg delete "HKLM\\SOFT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run" /f /v "OneDrive" >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer" /v link /t REG_BINARY /d 00000000 /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" /v "TaskbarGlomLevel" /t reg_dword /d "1" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f >nul 2>nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Services\\atapi\\Parameters" /v "EnableBigLba" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\services\\Tcpip\\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\services\\Tcpip\\Parameters" /v "DefaultTTL" /t REG_DWORD /d 80 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\Lsa" /v "limitblankpassworduse" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\Lsa" /v "forceguest" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\Lsa" /v "Restrictanonymous" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\Lsa" /v "Restrictanonymoussam" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\Session Manager" /v "AutoChkTimeOut" /t REG_DWORD /d 3 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\CurrentControlSet\\Services\\Messenger" /v "Start" /t REG_DWORD /d 4 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Memory Management" /v "LargePageMinimum" /t REG_DWORD /d "4294967295" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\CrashControl" /v "LogEvent" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\CrashControl" /v "AutoReboot" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\CrashControl" /v "SendAlert" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d 0 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\SecurePipeServers\\winreg" /v "CPUPriority" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\SecurePipeServers\\winreg" /v "PCIConcur" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\SecurePipeServers\\winreg" /v "FastDRAM" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\SecurePipeServers\\winreg" /v "AGPConcur" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\FileSystem" /v "ConfigFileAllocSize" /t REG_DWORD /d 500 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\SecurePipeServers\\winreg" /v "RemoteRegAccess" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\Windows" /v "NoPopUpsOnBoot" /t REG_SZ /d "0" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Memory Management\\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 1 /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Control Panel\\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Control Panel\\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Control Panel\\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f >nul', shell=True)
subprocess.call('reg add "HKLM\\SOFT\\Control Panel\\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul', shell=True)
subprocess.call('reg unload HKLM\\SOFT', shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbc\x98\xe5\x8c\x96\xe6\x88\x90\xe5\x8a\x9f\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackwrzsbar(self):
if not os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
threading.Thread(target=self.callbackwrzs, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()


def callbackwrzs(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
subprocess.call('XCOPY /s /e /y %s\\Windows\\Panther\\* %s:\\win10\\Windows\\Panther\\*' % (self.currdir, self.drv), shell=True)
subprocess.call('cmd.exe /c takeown /f "%s:\\win10\\Windows\\Web" /r /d y && icacls "%s:\\win10\\Windows\\Web" /grant administrators:F /t' % (self.drv, self.drv), shell=True)
subprocess.call('XCOPY /s /e /y %s\\Web\\Wallpaper\\Windows\\* %s:\\win10\\Windows\\Web\\Wallpaper\\Windows\\*' % (self.currdir, self.drv), shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = '\xe6\x97\xa0\xe4\xba\xba\xe5\x80\xbc\xe5\xae\x88\xe5\xae\x89\xe8\xa3\x85\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackwinsxsoptibar(self):
subprocess.call('dir /ad /b %s:\\win10\\Windows\\WinSxS >%s\\winsxsoptibar.txt' % (self.drv, self.temp), shell=True)
subprocess.call('findstr /i "amd64_3ware.inf.resources_" %s\\winsxsoptibar.txt >%s\\winsxsoptibar-2.txt' % (self.temp, self.temp), shell=True)
self.file3ware = ''
with open('%s\\winsxsoptibar-2.txt' % self.temp) as f:
for i in f.readlines():
i = i.strip()
self.file3ware = i

# WARNING: Decompyle incomplete


def callbackwinsxsopti(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
subprocess.call('dir /ad /b %s:\\win10\\Windows\\WinSxS >%s\\winsxsopti.txt' % (self.drv, self.temp), shell=True)
subprocess.call('findstr /i /v "amd64_microsoft-windows-t..languages.resources amd64_microsoft-windows-servicingstack x86_microsoft.windows.c..-controls.resources amd64_microsoft-windows-com-dtc-runtime amd64_microsoft.vc80.crt amd64_microsoft.vc90.crt amd64_microsoft.windows.c..-controls.resources amd64_microsoft.windows.common-controls amd64_microsoft.windows.gdiplus Catalogs InstallTemp Manifests x86_microsoft-windows-servicingstack x86_microsoft.vc80.crt x86_microsoft.vc90.crt x86_microsoft.windows.common-controls x86_microsoft.windows.gdiplus" %s\\winsxsopti.txt >%s\\winsxsopti-2.txt' % (self.temp, self.temp), shell=True)
with open('%s\\winsxsopti-2.txt' % self.temp) as f:
for i in f.readlines():
i = i.strip()
subprocess.call('%s\\NSudo.exe -U:C -P:E -ShowWindowMode:Hide cmd /c RD /Q /S "%s:\\win10\\Windows\\WinSxS\\%s"' % (self.currdir, self.drv, i), shell=True)

# WARNING: Decompyle incomplete


def callbackunmountbar(self):
if not os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe7\xb3\xbb\xe7\xbb\x9f\xe6\x89\xbe\xe4\xb8\x8d\xe5\x88\xb0\xe6\x8c\x87\xe5\xae\x9a\xe7\x9b\xae\xe5\xbd\x95\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
threading.Thread(target=self.callbackunmount, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()


def callbackunmount(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
if os.path.exists('"%s:\\win10\\PerfLogs"' % self.drv):
subprocess.call('%s\\NSudo.exe -U:C -P:E -ShowWindowMode:Hide cmd /c RD /Q /S "%s:\\win10\\PerfLogs"' % (self.currdir, self.drv), shell=True)
if os.path.exists('"%s:\\win10\\$Recycle.Bin"' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\$Recycle.Bin"' % self.drv, shell=True)
if os.path.exists('"%s:\\win10\\Users\\Default\\*.LOG1"' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Users\\Default\\*.LOG1"' % self.drv, shell=True)
if os.path.exists('"%s:\\win10\\Users\\Default\\*.LOG2"' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Users\\Default\\*.LOG2"' % self.drv, shell=True)
if os.path.exists('"%s:\\win10\\Users\\Default\\*.TM.blf"' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Users\\Default\\*.TM.blf"' % self.drv, shell=True)
if os.path.exists('"%s:\\win10\\Users\\Default\\*.regtrans-ms"' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Users\\Default\\*.regtrans-ms"' % self.drv, shell=True)
if os.path.exists('"%s:\\win10\\Windows\\INF\\*.log"' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\INF\\*.log"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\System32\\config\\*.LOG1' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\System32\\config\\*.LOG1"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\System32\\config\\*.LOG2' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\System32\\config\\*.LOG2"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\System32\\config\\*.TM.blf' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\System32\\config\\*.TM.blf"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\System32\\config\\*.regtrans-ms' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\System32\\config\\*.regtrans-ms"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\System32\\SMI\\Store\\Machine\\*.LOG1' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\System32\\SMI\\Store\\Machine\\*.LOG1"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\System32\\SMI\\Store\\Machine\\*.LOG2' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\System32\\SMI\\Store\\Machine\\*.LOG2"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\System32\\SMI\\Store\\Machine\\*.TM.blf' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\System32\\SMI\\Store\\Machine\\*.TM.blf"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\System32\\SMI\\Store\\Machine\\*.regtrans-ms' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\System32\\SMI\\Store\\Machine\\*.regtrans-ms"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\WinSxS\\ManifestCache\\*.bin' % self.drv):
subprocess.call('del /q /f "%s:\\win10\\Windows\\WinSxS\\ManifestCache\\*.bin"' % self.drv, shell=True)
subprocess.call('%s\\NSudo.exe -U:C -P:E -ShowWindowMode:Hide cmd /c RD /Q /S "%s:\\win10\\Windows\\CbsTemp"' % (self.currdir, self.drv), shell=True)
if not os.path.isdir('%s:\\win10\\Windows\\CbsTemp' % self.drv):
subprocess.call('md "%s:\\win10\\Windows\\CbsTemp"' % self.drv, shell=True)
if os.path.exists('%s:\\win10\\Windows\\WinSxS\\Temp\\PendingDeletes\\*' % self.drv):
subprocess.call('cmd.exe /c takeown /f "%s:\\win10\\Windows\\WinSxS\\Temp\\PendingDeletes\\*" && icacls "%s:\\win10\\Windows\\WinSxS\\Temp\\PendingDeletes\\*" /grant administrators:F /t& del /f /q "%s:\\win10\\Windows\\WinSxS\\Temp\\PendingDeletes\\*"' % (self.drv, self.drv, self.drv), shell=True)
if os.path.exists('%s:\\win10\\Windows\\WinSxS\\Temp\\TransformerRollbackData\\*' % self.drv):
subprocess.call('cmd.exe /c takeown /f "%s:\\win10\\Windows\\WinSxS\\Temp\\TransformerRollbackData\\*" && icacls "%s:\\win10\\Windows\\WinSxS\\Temp\\TransformerRollbackData\\*" /grant administrators:F /t& del /f /q "%s:\\win10\\Windows\\WinSxS\\Temp\\TransformerRollbackData\\*"' % (self.drv, self.drv, self.drv), shell=True)
if os.path.exists('%s:\\win10\\Windows\\WinSxS\\Temp' % self.drv):
subprocess.call('%s\\NSudo.exe -U:C -P:E -ShowWindowMode:Hide cmd /c RD /Q /S "%s:\\win10\\Windows\\WinSxS\\Temp"' % (self.currdir, self.drv), shell=True)
subprocess.call('%s\\NSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c del /f /q %s:\\SOFTWAREBKP' % (self.currdir, self.filewim[:1]), shell=True)
subprocess.call('Dism /Image:%s:\\win10 /Cleanup-Image /StartComponentCleanup &&Dism /Image:%s:\\win10 /Cleanup-Image /StartComponentCleanup /ResetBase' % (self.drv, self.drv), shell=True)
subprocess.call('Dism /Unmount-Image /mountdir:%s:\\win10 /commit' % self.drv, shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = '\xe4\xbf\x9d\xe5\xad\x98\xe5\xae\x8c\xe6\x88\x90!'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackesd2wimt(self):
start = time.perf_counter()
subprocess.call('DISM /Export-Image /SourceImageFile:%s /SourceIndex:1 /DestinationImageFile:%s.wim /compress:max /CheckIntegrity' % (self.filewim, self.filewim2), shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = '\xe8\xbd\xac\xe6\x8d\xa2\xe6\x88\x90\xe5\x8a\x9f\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackesd2wim(self):
self.mflag = False
self.update_idletasks()
self.canvas.delete(self.txt)
self.filewim = filedialog.askopenfilename(title='\xe8\xaf\xb7\xe9\x80\x89\xe6\x8b\xa9\xe8\xa6\x81\xe8\xbd\xac\xe6\x8d\xa2\xe7\x9a\x84esd\xe6\x96\x87\xe4\xbb\xb6'.encode('raw_unicode_escape').decode(), initialdir=os.chdir('../'), filetypes=[
('esd\xe6\x96\x87\xe4\xbb\xb6', '.esd')])
self.filewim = self.filewim.replace('/', '\\')
self.filewim2 = self.filewim.split('.')[0]
if os.path.exists('%s' % self.filewim):
num = 430
threading.Thread(target=self.callbackesd2wimt, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()
return None
self.canvas.delete(self.txt)
self.str = ' \xe4\xbd\xa0\xe9\x83\xbd\xe6\xb2\xa1\xe9\x80\x89\xe6\x8b\xa9esd\xe6\x96\x87\xe4\xbb\xb6\xe8\xbd\xac\xe6\x8d\xa2\xe4\xb8\xaa\xe6\xaf\x9b\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackwimopt(self):
start = time.perf_counter()
subprocess.call('%s\\wimlib-imagex.exe optimize %s --check --compress=lzx:100' % (self.currdir, self.filewim), shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = '\xe9\x87\x8d\xe6\x9e\x84\xe4\xbc\x98\xe5\x8c\x96\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackwimopti(self):
self.mflag = False
self.update_idletasks()
self.canvas.delete(self.txt)
self.filewim = filedialog.askopenfilename(title='\xe6\x89\x93\xe5\xbc\x80wim\xe6\x96\x87\xe4\xbb\xb6'.encode('raw_unicode_escape').decode(), initialdir=os.chdir('../'), filetypes=[
('wim\xe6\x96\x87\xe4\xbb\xb6', '.wim')])
self.filewim = self.filewim.replace('/', '\\')
if os.path.exists('%s' % self.filewim):
num = 520
threading.Thread(target=self.callbackwimopt, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()
return None
self.canvas.delete(self.txt)
self.str = ' \xe9\x83\xbd\xe6\xb2\xa1\xe9\x80\x89\xe6\x8b\xa9wim\xe6\x96\x87\xe4\xbb\xb6\xe9\x87\x8d\xe6\x9e\x84\xe5\x95\xa5\xe5\x95\x8a\xef\xbc\x9f\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackwim2esdt(self):
start = time.perf_counter()
subprocess.call('DISM /Export-Image /SourceImageFile:%s /SourceIndex:1 /DestinationImageFile:%s.esd /compress:recovery /CheckIntegrity' % (self.filewim, self.filewim2), shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = '\xe8\xbd\xac\xe6\x8d\xa2\xe6\x88\x90\xe5\x8a\x9f\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def callbackwim2esd(self):
self.mflag = False
self.update_idletasks()
self.canvas.delete(self.txt)
self.filewim = filedialog.askopenfilename(title='\xe8\xaf\xb7\xe9\x80\x89\xe6\x8b\xa9\xe8\xa6\x81\xe8\xbd\xac\xe6\x8d\xa2\xe7\x9a\x84wim\xe6\x96\x87\xe4\xbb\xb6'.encode('raw_unicode_escape').decode(), initialdir=os.chdir('../'), filetypes=[
('wim\xe6\x96\x87\xe4\xbb\xb6', '.wim')])
self.filewim = self.filewim.replace('/', '\\')
self.filewim2 = self.filewim.split('.')[0]
if os.path.exists('%s' % self.filewim):
num = 5715
threading.Thread(target=self.callbackwim2esdt, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()
return None
self.canvas.delete(self.txt)
self.str = ' \xe4\xbd\xa0\xe9\x83\xbd\xe6\xb2\xa1\xe9\x80\x89\xe6\x8b\xa9wim\xe6\x96\x87\xe4\xbb\xb6\xe8\xbd\xac\xe6\x8d\xa2\xe4\xb8\xaa\xe6\xaf\x9b\xef\xbc\x81'
self.mylabel(self.str)


def callbackupnetbar(self):
if not os.listdir('%s\\sxs' % self.currdir):
self.canvas.delete(self.txt)
self.str = '\xe8\xaf\xb7\xe6\x8a\x8a.Net\xe6\x94\xbe\xe5\x9c\xa8sxs\xe7\x9b\xae\xe5\xbd\x95\xe4\xb8\x8b\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
if not os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe4\xbd\xa0\xe9\x83\xbd\xe6\xb2\xa1\xe6\x8c\x82\xe8\xbd\xbd\xe6\x9b\xb4\xe6\x96\xb0\xe4\xb8\xaa\xe6\xaf\x9b\xe5\x95\x8a\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
threading.Thread(target=self.callbackupnet, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()


def callbackupnet(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
subprocess.call('Dism /image:%s:\\win10 /add-package /packagepath:%s\\sxs' % (self.drv, self.currdir), shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = 'Net\xe6\x9b\xb4\xe6\x96\xb0\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'
self.mylabel(self.str)


def callbackupdatebar(self):
if not os.listdir('%s\\Patch' % self.currdir):
self.canvas.delete(self.txt)
self.str = '\xe8\xaf\xb7\xe6\x8a\x8a\xe8\xa1\xa5\xe4\xb8\x81\xe6\x94\xbe\xe5\x9c\xa8Patch\xe7\x9b\xae\xe5\xbd\x95\xe4\xb8\x8b\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
if not os.path.exists('%s:\\win10\\Windows\\system32\\config\\SOFTWARE' % self.drv):
self.canvas.delete(self.txt)
self.str = '\xe4\xbd\xa0\xe9\x83\xbd\xe6\xb2\xa1\xe6\x8c\x82\xe8\xbd\xbd\xe6\x9b\xb4\xe6\x96\xb0\xe4\xb8\xaa\xe6\xaf\x9b\xe5\x95\x8a\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)
return None
num = None
threading.Thread(target=self.callbackupdate, args=()).start()
threading.Thread(target=self.probar, args=(num,)).start()


def callbackupdate(self):
self.mflag = False
start = time.perf_counter()
self.update_idletasks()
self.canvas.delete(self.txt)
subprocess.call('Dism /image:%s:\\win10 /add-package /packagepath:%s\\Patch' % (self.drv, self.currdir), shell=True)
self.mflag = True
print(int(time.perf_counter() - start))
self.str = '\xe8\xa1\xa5\xe4\xb8\x81\xe6\x9b\xb4\xe6\x96\xb0\xe5\xae\x8c\xe6\x88\x90\xef\xbc\x81'.encode('raw_unicode_escape').decode()
self.mylabel(self.str)


def probar(self, bartime):
self.A = Style()
self.A.theme_use('winnative')
self.A.configure('fp.Horizontal.TProgressbar', troughcolor='grey', background='green', lightcolor='#0078d7', darkcolor='#0078d7', relief=tk.GROOVE)
self.pbar = Progressbar(self, length=480, orient=HORIZONTAL, mode='determinate', style='fp.Horizontal.TProgressbar')
self.pbar.place(x=150, y=420)
self.pbar['value'] = 0
self.pbar['maximum'] = bartime
for i in range(bartime):
time.sleep(1)
self.pbar['value'] = i + 1
if self.mflag == True or i == self.pbar['maximum'] - 1:
self.pbar['value'] = self.pbar['maximum']
return None
self.update()
self.pbar.stop()


def mylabel(self, str):
self.txt = self.canvas.create_text(370, 400, text=self.str, fill='red', font=('\xe6\xa5\xb7\xe4\xbd\x93'.encode('raw_unicode_escape').decode(), 28))


def callbackregister(self):
self.regiet = Regist()
self.regiet.after(50)
self.regiet.mainloop()


def callbackhelp(self):
self.help = Help()
self.help.after(50)
self.help.mainloop()


def callbackabout(self):
self.about = About()
self.about.after(50)
self.about.mainloop()


def setup_UI(self):
self.frm.pack()
self.canvas.pack()
menubar = tk.Menu(self, background='blue', fg='grey')
file = tk.Menu(menubar, tearoff=False, background='white')
edit = tk.Menu(menubar, tearoff=False, background='white')
file.add_command(label='\xe6\x8c\x82\xe8\xbd\xbd\xe6\x98\xa0\xe5\x83\x8f'.encode('raw_unicode_escape').decode(), command=self.callbackmount)
file.add_command(label='\xe4\xbf\x9d\xe5\xad\x98\xe6\x98\xa0\xe5\x83\x8f'.encode('raw_unicode_escape').decode(), command=self.callbackunmountbar)
file.add_command(label='\xe5\x8d\xb8\xe8\xbd\xbd\xe6\xb8\x85\xe7\x90\x86'.encode('raw_unicode_escape').decode(), command=self.callbackexit)
file.add_command(label='\xe9\x80\x80\xe5\x87\xba\xe7\xa8\x8b\xe5\xba\x8f'.encode('raw_unicode_escape').decode(), command=self.destroy)
edit.add_command(label='\xe5\xb8\xae\xe5\x8a\xa9\xe6\x96\x87\xe6\xa1\xa3'.encode('raw_unicode_escape').decode(), command=self.callbackhelp)
edit.add_command(label='\xe6\x8d\x90 \xe8\xb5\xa0'.encode('raw_unicode_escape').decode(), command=self.callbackregister)
edit.add_command(label='\xe5\x85\xb3 \xe4\xba\x8e'.encode('raw_unicode_escape').decode(), command=self.callbackabout)
menubar.add_cascade(label=' \xe6\x96\x87 \xe4\xbb\xb6 '.encode('raw_unicode_escape').decode(), menu=file)
menubar.add_cascade(label=' \xe5\xb8\xae \xe5\x8a\xa9 '.encode('raw_unicode_escape').decode(), menu=edit)
self.config(menu=menubar)
x1 = 85
y1 = 60
self.img1 = tk.PhotoImage(file='%s\\image\\mount.png' % self.currdir)
self.img1 = self.img1.subsample(9, 9)
self.canvas.create_image(x1, y1, image=self.img1)
self.butmount = tk.Button(self, text='\xe6\x8c\x82\xe8\xbd\xbd\xe6\x98\xa0\xe5\x83\x8f'.encode('raw_unicode_escape').decode(), width=8, height=1,bg= 'white', command=self.callbackmount)
self.butmount.place(x=50, y=90)
x2 = 215
y2 = 60
self.img2 = tk.PhotoImage(file='%s\\image\\unapp.png' % self.currdir)
self.img2 = self.img2.subsample(4)
self.canvas.create_image(x2, y2, image=self.img2)
self.butunapp = tk.Button(self, text='\xe5\x8d\xb8\xe8\xbd\xbdApp'.encode('raw_unicode_escape').decode(), width=8, height=1,bg= 'white', command=self.callbackunapp)
self.butunapp.place(x=180, y=90)
x3 = 345
y3 = 55
self.img3 = tk.PhotoImage(file='%s\\image\\onedrive.png' % self.currdir)
self.img3 = self.img3.subsample(3)
self.canvas.create_image(x3, y3, image=self.img3)
self.butonedrive = tk.Button(self, text='\xe5\x8d\xb8\xe8\xbd\xbdOneDr'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackonedrivebar)
self.butonedrive.place(x=310, y=90)
x16 = 85
y16 = 405
self.img16 = tk.PhotoImage(file='%s\\image\\exit.png' % self.currdir)
self.img16 = self.img16.subsample(8)
self.canvas.create_image(x16, y16, image=self.img16)
self.butexit = tk.Button(self, text='\xe5\x8d\xb8\xe8\xbd\xbd\xe6\xb8\x85\xe7\x90\x86'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackexit)
self.butexit.place(x=50, y=440)
x4 = 475
y4 = 55
self.img4 = tk.PhotoImage(file='%s\\image\\defender.png' % self.currdir)
self.img4 = self.img4.subsample(4)
self.canvas.create_image(x4, y4, image=self.img4)
self.butdelwd = tk.Button(self, text='\xe5\x8d\xb8\xe8\xbd\xbdDefend'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackdelwdbar)
self.butdelwd.place(x=440, y=90)
x5 = 610
y5 = 60
self.img5 = tk.PhotoImage(file='%s\\image\\systemjj.png' % self.currdir)
self.img5 = self.img5.subsample(4)
self.canvas.create_image(x5, y5, image=self.img5)
self.butgenlite = tk.Button(self, text='\xe9\x80\x9a\xe7\x94\xa8\xe7\xb2\xbe\xe7\xae\x80'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackgenlitebar)
self.butgenlite.place(x=570, y=90)
x6 = 85
y6 = 170
self.img6 = tk.PhotoImage(file='%s\\image\\edge.png' % self.currdir)
self.img6 = self.img6.subsample(8, 8)
self.canvas.create_image(x6, y6, image=self.img6)
self.butedge = tk.Button(self, text='\xe5\x8d\xb8\xe8\xbd\xbdEdge'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackedgebar)
self.butedge.place(x=50, y=205)
x7 = 215
y7 = 170
self.img7 = tk.PhotoImage(file='%s\\image\\om.png' % self.currdir)
self.img7 = self.img7.subsample(4)
self.canvas.create_image(x7, y7, image=self.img7)
self.butopt = tk.Button(self, text='\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbc\x98\xe5\x8c\x96'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackoptbar)
self.butopt.place(x=180, y=205)
x8 = 345
y8 = 170
self.img8 = tk.PhotoImage(file='%s\\image\\wrzs.png' % self.currdir)
self.img8 = self.img8.subsample(2, 3)
self.canvas.create_image(x8, y8, image=self.img8)
self.butwrzs = tk.Button(self, text='\xe6\x97\xa0\xe4\xba\xba\xe5\x80\xbc\xe5\xae\x88'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackwrzsbar)
self.butwrzs.place(x=310, y=205)
x9 = 475
y9 = 170
self.img9 = tk.PhotoImage(file='%s\\image\\winsxsopt.png' % self.currdir)
self.img9 = self.img9.subsample(7, 7)
self.canvas.create_image(x9, y9, image=self.img9)
self.butwinsxsopti = tk.Button(self, text='WinSxS\xe4\xbc\x98\xe5\x8c\x96'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackwinsxsoptibar)
self.butwinsxsopti.place(x=440, y=205)
x15 = 610
y15 = 285
self.img15 = tk.PhotoImage(file='%s\\image\\unmount.png' % self.currdir)
self.img15 = self.img15.subsample(2, 2)
self.canvas.create_image(x15, y15, image=self.img15)
self.butunmount = tk.Button(self, text='\xe4\xbf\x9d\xe5\xad\x98\xe6\x98\xa0\xe5\x83\x8f'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackunmountbar)
self.butunmount.place(x=570, y=320)
x13 = 345
y13 = 280
self.img13 = tk.PhotoImage(file='%s\\image\\esd2wim.png' % self.currdir)
self.img13 = self.img13.subsample(6)
self.canvas.create_image(x13, y13, image=self.img13)
self.butesd2wim = tk.Button(self, text='esd2wim', width=9, height=1,bg= 'white', command=self.callbackesd2wim)
self.butesd2wim.place(x=310, y=320)
x12 = 215
y12 = 285
self.img12 = tk.PhotoImage(file='%s\\image\\wim2esd.png' % self.currdir)
self.img12 = self.img12.subsample(7, 7)
self.canvas.create_image(x12, y12, image=self.img12)
self.butwim2esd = tk.Button(self, text='wim2esd', width=9, height=1,bg= 'white', command=self.callbackwim2esd)
self.butwim2esd.place(x=180, y=320)
x10 = 610
y10 = 170
self.img10 = tk.PhotoImage(file='%s\\image\\upnet.png' % self.currdir)
self.img10 = self.img10.subsample(2)
self.canvas.create_image(x10, y10, image=self.img10)
self.butupnet = tk.Button(self, text='\xe6\x9b\xb4\xe6\x96\xb0.Net'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackupnetbar)
self.butupnet.place(x=570, y=205)
x11 = 85
y11 = 285
self.img11 = tk.PhotoImage(file='%s\\image\\update.png' % self.currdir)
self.img11 = self.img11.subsample(1, 2)
self.canvas.create_image(x11, y11, image=self.img11)
self.butupdate = tk.Button(self, text='\xe6\x9b\xb4\xe6\x96\xb0\xe8\xa1\xa5\xe4\xb8\x81'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackupdatebar)
self.butupdate.place(x=50, y=320)
x14 = 475
y14 = 285
self.img14 = tk.PhotoImage(file='%s\\image\\wimopti.png' % self.currdir)
self.img14 = self.img14.subsample(5, 4)
self.canvas.create_image(x14, y14, image=self.img14)
self.butwimopti = tk.Button(self, text='\xe9\x87\x8d\xe6\x9e\x84\xe4\xbc\x98\xe5\x8c\x96'.encode('raw_unicode_escape').decode(), width=9, height=1,bg= 'white', command=self.callbackwimopti)
self.butwimopti.place(x=440, y=320)


def exitWinLiteMain(self):
self.destroy()

__classcell__ = None


if __name__ == '__main__':
winmain = WinLiteMain()
winmain.after(50)
winmain.mainloop()