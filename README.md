# macOS Ubuntu

Install an Ubuntu 16.04 VM on macOS using [xhyve].

## Download ubuntu

16.04.1 server work for author and
16.04.5 works for me

## Install xhyve

```
brew install xhyve
```

## Get booting kernel

```
sudo ./prepare.sh ~/Downloads/ubuntu-16.04.5-server-amd64.iso
```

## Create storage and boot to ISO

```
sudo ./create.sh ~/Downloads/ubuntu-16.04.5-server-amd64.iso
```

After booting, install Ubuntu just like you normally would.

Pro tip: Don't resize your terminal while you're going through the installer.

When you get to this question.

```
Install the GRUB boot loader to the master boot record?
```

Make sure you say, "yes".

## Very important DO NOT QUIT Installation

### Grab newer kernel from install

When you get to "Installation complete", select "Go Back". Then, "Execute a
shell".

Find your current IP address.

```
/sbin/ip addr show enp0s2
2: enp0s2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    inet 192.168.64.8/24 brd 192.168.64.255 scope global enp0s2
```

Next, we're gonna copy some files back to the host. The exact name of the
following files might be slightly different, depending on when you download the
Ubuntu server ISO.

In the guest, run this.

```
cd /target/boot
cat initrd.img-4.4.0-131-generic | nc -l -p 1234
# run the host command and make sure the ip addres is right 
cat vmlinuz-4.4.0-131-generic | nc -l -p 1234
# run the host command and make sure the ip addres is right 
ls -al
# check the size is correct
```

On the host, run this.

```
cd boot/
nc 192.168.64.8 1234 > initrd.img-4.4.0-131-generic
nc 192.168.64.8 1234 > vmlinuz-4.4.0-131-generic
ls -al
# check the size is correct
cd ../
```

Now, you can `exit` the shell and finish the installation.

## Modify the start.sh

If the file change e.g. under 16.04.1 it is 4.4.0.31 but 16.04.5, you have modify the start.sh to say it is now 4.4.0.131

## Start your new OS

```
sudo ./start.sh
```

## First steps

Here are some things you should probably do after logging in.

```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y xterm
echo "export TERM=xterm-256color" >> $HOME/.bashrc
```

`xterm` is important because it'll install the `resize` command. You'll need to
manually resize the terminal dimensions because we're using a serial TTY or
something.

The default terminal is `vt220`, which doesn't have colors by default. We're
probably more used to `xterm`.

Everytime you resize your terminal, you need to run `resize`. Otherwise, your
output will get jacked.

## Reboot

That's it! You don't really need to reboot, but here's what that looks like.

```
jaime@xhyve:~$ sudo poweroff
[  636.675689] reboot: System halted
jaime@mac:~$ sudo ./start.sh
```

## Launch Daemons

The purpose is unclear.  But I think it may be because the author want to boot the ubuntu when MacOS reboot.  
Not sure it is what you want and hence if you are not sure, there is no need.  
And if you need it, you have to modify the file variadico.xhyve.ubuntu.plist as it contains the directory where the file belong

```
sudo chown root variadico.xhyve.ubuntu.plist
sudo ln -s $(pwd)/variadico.xhyve.ubuntu.plist /Library/LaunchDaemons/
sudo launchctl load /Library/LaunchDaemons/variadico.xhyve.ubuntu.plist

# Verify status
sudo launchctl list | grep "xhyve"

# Stop
sudo launchctl unload /Library/LaunchDaemons/variadico.xhyve.ubuntu.plist
```


[xhyve]: https://github.com/mist64/xhyve
