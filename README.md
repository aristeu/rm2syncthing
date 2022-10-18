These scripts are used to automatically convert Remarkable 2 documents into
pdf and png so they can be viewed by other devices. It uses syncthing on both
the remarkable2 and a computer. In my setup I have a server running 24/7 and I
get the pdf and png synchronized to my phone, using syncthing as well.

-----------
TL/DR for people comfortable with Linux:
- both scripts have the source and output directories as variables, edit them
- you need: imagemagick, rmrl python3 module (use pip to install), inotifywait
- two versions: remarkable2_update.sh runs on cron, remarkable2_inotify.sh uses
  inotify to keep monitoring the directory. Can be run as systemd user service,
  see .service provided.
-----------

Keep in mind this assumes you have a computer running Linux. You can run this
on Windows or MacOS provided you have bash, python and everything else needed.
Since I don't use either, I can't help you on that.

If you don't currently use syncthing you'll need to set it up first:

	https://syncthing.net

Installing syncthing on remarkable2:

	https://github.com/evidlo/remarkable_syncthing

Python module rmrl is needed for converting from Remarkable's format to pdf, so
install it on your computer:

	$ pip3 install rmrl

You also need ImageMagick to convert the pdf to png. Consult your distribution's
package manager to determine the package you need. If you don't want the png
version, you can just comment the line with 'convert'.

There are two scripts that can be run on your ocmputer:

	remarkable2_update.sh - cron version
	remarkable2_inotify.sh - inotify version (requires inotifywait)

Cron version:
	- copy the script to a location of your choosing
	- edit the script and change the RM2 variable to point to the directory
	  syncthing syncs remarkable2's files and where the output you want it
	  to be
	- create a cron entry:
		* * * * * <path you picked>/remarkable2_update.sh
	- this will run every minute. If you're not familiar with cron, check
		man 5 crontab
	  to change how often it'll run

Inotify version:
	- copy the script to a location of your choosing
	- either run it manually (it'll keep watching for changes) or you can
	  use the service file if you use systemd:
		- edit the service file to include the path to the script
		- create the directory:
			mkdir -p ~/.config/systemd/user
		- copy the .service file there
		- make systemd scan for new service files:
			systemctl --user daemon-reload
		- enable the service so it runs on boot
			systemctl --user enable rm2syncthing
		- start the service
			systemctl --user start rm2syncthing
