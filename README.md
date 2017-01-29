# Clean Your ROM

Clean Your ROM (CYR) is a command line tool written in Ruby, that assists in organizing ROM files based on the standard naming conventions used in the ROM file names.  I built this script to assist me in finding ROMs for my RetroPie.  Use at your own risk, and please, don't steal things.

### Clean Your ROM can:

- Create directory structures to organize your files and is compatible with your RetroPie.
- Identify files by device, extension, build type and region
- Copy appropriate files to a destination directory that matches the device they belong to.
- Copy alternate files (unmatched) to their own directory for later use.
- Copy duplicate files (similar name and file path) to their own directory for later use.


# Installing Clean Your ROM

You will have to have Ruby installed on your machine for these scripts to work.

To install Clean Your ROM, clone the repository into the location where you want the file to be installed.  In a terminal, go to the cloned directory and run the following command:

```bash
sudo ruby install.rb
```

Once the install is complete, you should be able to run Clean Your ROM from any directory by simply typing the following command:

```bash
clean_your_rom
```


# Uninstalling Clean Your ROM

You will have to have Ruby installed on your machine for these scripts to work.

To uninstall Clean Your ROM, in a terminal, go to the cloned where you first
installed CYR from.  Run the following command:

```bash
sudo ruby uninstall.rb
```


# License

This code is distributed under the MIT license.

Copyright 2017 John S. MacGregor.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.


# Helpful Things

### 7Zip Extraction Helper

If you want to extract all of the 7Zip files in a directory to a directory named
for the source file, you can use this bash command:

```bash
for file in ./*.7z; do filename=$(basename "$file"); filename="${filename%.*}"; mkdir -p "$filename"; 7za x -r -y -o"$filename" "$file"; done;
```

### SCP Command to Copy Files to RetroPie

SCP can be used to bulk copy the files from your local machine to your RetroPie.
Replaces the [variables] in the following command with the elements that match
your needs:

```bash
scp *.{n64,z64} pi@[retropie_ip_address]:/home/pi/RetroPie/roms/[system_short_name]
```

# Code Upkeep and Contributions

I have limited resources to pay attention to this code base, but if you would like to fork and update the code on your own, all I ask is attribution for the original code and that you use it in accordance with the license.   You can also create issues and offer code fixes & feature updates, which I will try to review in a timely manner, but no promises.
