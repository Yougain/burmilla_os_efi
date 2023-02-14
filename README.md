## burmilla_os_efi
# create_burmillaos_efi_iso
  A script for creating an iso image of BurmillaOS installer with EFI. When you execute the command without arguments, you can create latest stable version. When you provide "rc" or "beta" for first argument, you can create latest "rc" or "beta" version.<br>
  You can directly login through SSH by username, 'rancher' and password, 'rancher', because "rancher.password=rancher" has been already set in kernel parameters of grub-setting of created iso images.<br>
  CAUTION: Do not alter label of iso image. The label must be 'rancheros' (not 'burmillaos'), or installer fails when you use USB-based iso installer created by Windows programs (ex. rufus).<br>
  ```
  $ ./create_burmillaos_efi_iso [|rc|beta]
  　...... # Downloading BurmillaOS and Ubuntu iso images.
  　...... # Copy files with EFI function from Ubuntu iso image to a new BurmillaOS iso image.
  　# You get ~/burmillaos_efi/burmillaos-vx.x.x.efi.iso finally.
  $ ls ~/burmillaos_efi
  burmillaos-vx.x.x.efi.iso  burmillaos-vx.x.x.iso  ubuntu-22.04.1-live-server-amd64.iso
  ```
# install_burmillaos_on_btrfs
A scpipt for installing RancherOS on btrfs partition created in /dev/sda of a baremetal server.<br>
After booting up a bare-metal server by burmillaos-vx.x.x.efi.iso, execute following command from your remote terminal outside of the server.
 ```
$ ./install_burmillaos_on_btrfs \
	[server name] \
	[server's ssh port number after installation] \
	[dhcp-provided ip address during installation] \
	[server's fixed ip address after installation]

For example,
$ ./install_burmillaos_on_btrfs mainsv 20122 192.168.0.11 192.168.0.201
 ```
If you omit ssh port number, it will be randomly decided by the script. Public key, ~/.ssh/id_ed25519 in your terminal will be registered as an authorized key for user, 'burmilla'. The server name (or new ip if it is omitted), ssh port number and user 'burmilla' will be registered in ~/.ssh/config, and you can logon simply by executing 'ssh [server name]' from your terminal. 

## References
https://blog.hugopoi.net/2020/03/01/install-rancheros-on-freenas-11-3/<br>
https://www.tecmint.com/upgrade-centos-7-to-centos-8/<br>
https://www.cyberciti.biz/howto/how-to-migrate-from-centos-8-to-almalinux-conversion/<br>
https://www.centlinux.com/2022/07/upgrade-your-servers-from-rocky-linux-8-to-9.html<br>
