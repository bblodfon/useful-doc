# Useful Linux commands

## Encrypt/Decrypt files

```
gpg -c filename
gpg -d filename.gpg
```

Don't ever cache the password:
```
vim ~/.gnupg/gpg-agent.conf

# copy-paste following two lines
default-cache-ttl 1
max-cache-ttl 1

echo RELOADAGENT | gpg-connect-agent
```

## CPU average usage (top)

```
top -b -n1 -u `whoami` | sed 1,7d | awk '{i +=  $9} END {print i/100}'
```

## WiFi commands

Local network-related devices status:
```
nmcli dev status
```

Is WiFi on? Turn it on (or off)!
```
nmcli radio wifi
nmcli radio wifi on
```

Available WiFi networks:
```
nmcli dev wifi list
```

Connect to a specific WiFi:
```
sudo nmcli dev wifi connect <network-ssid>
```

## Find monitor model

```
sudo apt-get install read-edid
sudo get-edid | parse-edid
```

## Break paragraph to multiple sentences, each in a new line

Paragraph is like: `AAaa. Bbbbb. Cccc.`.
What you get is: `AAaa.\nBbbbb.\nCccc.`

`sed -i 's/\. /\.\n/g' test.txt`

## Markdown to HTML/DOCX (pandoc)

```
pandoc test.md -f markdown -t html -s -o test.html
pandoc test.md -f markdown -t docx -o test.docx
```

## Latex to MathJax for HTML use


`math.text` has equations like `$a=b+c$`

```
pandoc math.text -s --mathjax -o mathMathJax.htm
```

## find start time of a long-running process

`ps -eo pid,lstart,cmd | grep process_name`

## grep pattern in many files and get back also the file name

Find in all *.html* files inside a directory, the mentions of string 'xaxa'
```
find . -name \*.html -print0 | xargs -0 grep -n -H xaxa
```

## Recursively search in directories and cat files

E.g. my current directory has mutliple directories that each one has multiple
files which I want to `cat` and find a pattern:
```
find . -type f -exec cat {} + | grep stable | wc -l
```

## change many filenames

Let's say I have many filenames in a directory which have the substring `_rand_` and I wanna change that substring to `_whatever_`.
Run inside the directory:

```
find . -type f -name '*_rand_*' | while read FILE ; do
    newfile="$(echo ${FILE} |sed -e 's/_rand_/_whatever_/')";
    mv "${FILE}" "${newfile}";
done
```

Another way (one liner):

```
for file in `ls | grep "_rand_"`; do mv "$file" "${file/_rand_/_whatever_}"; done
```

## on symbolic links

Create a symbolic link: `ln -s /full_path_to/real_exe_file_target /full_path_to/link`

Delete a symbolic link: `unlink /path_to/link`

## mount external disk

```
sudo fdisk -l
# usually it's on `/dev/sdb1` partition
mkdir /media/disk
sudo mount /dev/sdb1 /media/disk
```

After you are done, run: `sudo umount /media/disk`

## Add command path permanently

Go to `/etc/profile.d` and create a `test.sh` file.
Put inside something like this:
```
EXEC_HOME=/usr/bin/my-exetutable
export EXEC_HOME
```

Then, with `echo $EXEC_HOME` it's gonna be known to the whole system!

## bash terminal - counting dots loop

To see an incremental counter:

`i=0; while true; do sleep 1; echo $i; i=$((i+1)); done`

To see dots (server connection awaiting!)

`while true; do echo -n .; sleep 1; done`

## Change text-scaling-factor in Ubuntu 18.04

Make all text bigger/smaller:

```
gsettings set org.gnome.desktop.interface text-scaling-factor 1.5 # big
gsettings set org.gnome.desktop.interface text-scaling-factor 1.1 # small
```

## Archiving with tar

`tar -czvf filename.tar.gz /path/to/dir1`

## Extract with tar

`tar -xzvf filename.tar.gz`

To another directory:
```
mkdir new-dir
tar -C new-dir -xzvf filename.tar.gz
```

## Extract one file from `tar.gz` file

`tar -xf example.tar.gz <file-name>`

## list tar.gz file contents with depth

Download perl script: [treeify](https://github.com/grawity/code/blob/master/misc/treeify)
and run: `tar -tf <file>.tar.gz | treeify -d 2`

## Nice bash aliases

```
function cd_up() {
  cd $(printf "%0.s../" $(seq 1 $1 ));
}

alias 'cd..'='cd_up'

alias 'com'='git commit'
alias 'cam'='git commit --amend'
alias 'l'='ls -ltrh'
alias 'off'='sudo poweroff'
```

Navigate quickly directories like this: `cd.. 4`!

## change prompt look in terminal

Add to `~/.bashrc` this line:

`export PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]~\[\033[00m\]\$ '`

or this one that includes the name of the current working dir:

`export PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;36m\][\W]\[\033[00m\]\$ '`

Notes:

- 32m => green, 00m => white, 34m => blue, 36m => Cyan
- \u => user, \W => working dir

## Convert many PDF files to EPS

```
#!/bin/bash

pdf_files=`ls | grep pdf`

for file in ${pdf_files}; do
  name="$(basename "${file}" .pdf)"
  echo $name
  #gs -q -dNOCACHE -dNOPAUSE -dBATCH -dSAFER -sDEVICE=eps2write -sOutputFile=$name.eps $file
  # better quality
  inkscape $file --export-eps=$name.eps
done
```

## shrink/optimize pdf

- Using a script: http://www.alfredklomp.com/programming/shrinkpdf/
- Using `ps2pdf`: `ps2pdf -dPDFSETTINGS=/printer ags.pdf out.pdf`

```
-dPDFSETTINGS=/screen   (screen-view-only quality, 72 dpi images)
-dPDFSETTINGS=/ebook    (low quality, 150 dpi images)
-dPDFSETTINGS=/printer  (high quality, 300 dpi images)
-dPDFSETTINGS=/prepress (high quality, color preserving, 300 dpi imgs)
-dPDFSETTINGS=/default  (almost identical to /screen)
```

## rotate pdf

```
qpdf in.pdf out.pdf --rotate=90
```

## crop pdf

Remember, margins are (left, right, top, bottom).
The next command will leave only the top-right part of the input pdf:
```
pdfcrop --margins '-280 0 0 -600' in.pdf out.pdf
```

## svg to pdf

```
cairosvg in.svg -o out.pdf
```

## svg to png

See [svg2pdf file](https://github.com/bblodfon/useful-doc/blob/master/svg2png).

## pdf to png/svg with awesome quality

See [pdf2png file](https://github.com/bblodfon/useful-doc/blob/master/pdf2png) for all following commands in one script.

Let's say you have a (1-page) pdf: `test.pdf` that contains an image or diagram
and you want to put it in a presentation/article/word etc in an
appropriate format and with decent quality.

First crop it:
```
pdfcrop --margins 10 test.pdf test_crop.pdf
```

Then convert it to the format you like:
```
# PNG, 600 ppi
pdftoppm -png -r 600 test_crop.pdf test

# SVG
pdf2svg test_crop.pdf test.svg
```

## jpg to pdf

`convert ticket_1.jpg ticket_2.jpg ticket.pdf`

## reduce size of scanned pdf

```
pdf2ps input.pdf output.ps
ps2pdf output.ps -dPDFSETTINGS=/ebook output.pdf
```

See also this [askubuntu question](https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file/256449#256449) for more pdf options.

## Decrypt password-protected pdf

`qpdf --decrypt in.pdf out.pdf`

## select pages from pdf

`pdftk test.pdf cat 2-4 output out.pdf`

## resize pdf

`pdfjam --outfile out.pdf --papersize '{6.125in,9.250in}' in.pdf`

## pdf info

`pdfinfo .pdf`

## merge 2 or more pdfs

`pdftk file1.pdf file2.pdf cat output mergedfile.pdf`

## take specific characters from each line in a file

`cut -c 1-30 <file-name>`

## Do something on many files in a dir

*Something* can be: rendering notebooks to HTML or checking if the files are
the same as other files for example
```bash
#!/bin/bash

files=`ls`
dir="/somewhere/over/the/rainbow"
rmd_files=`ls | grep Rmd`

for file in ${rmd_files}; do
  filename_no_extension="$(basename "${file}" .Rmd)"
  diff -s $dir$file $file
  Rscript -e "library(rmarkdown); rmarkdown::render(\"./$file\",\"html_document\")"
done
```

## Make desktop icons appear and disappear
```
gsettings set org.gnome.desktop.background show-desktop-icons false
```

## Find the sum in MB of files in a directory
`ls | xargs stat --format=%s | awk '{s+=$1} END {print s/(1024*1024)}'`

## Count lines of source code
`find . -name '*.php' | xargs wc -l`
or use cloc: `apt-get install cloc`

## Delete files efficiently

```
find . -maxdepth 1 -name "something*" -print0 | xargs -0 rm
```

## List files in a dir efficiently

Copy the [listdir.c](./listdir.c) file. Then:
```
gcc listdir.c -o listdir
./listdir /dirWithTooManyFiles
```

## Count and change the reserved space in an ext4 partition 'ONLINE'

Change the reserved space to 1%: `tune2fs -m 1 /dev/sdb1`
Count the percentage:
```
a=$(tune2fs -l /dev/sdb1 | grep -i 'Reserved block count' | awk '{ print $4 }')
b=$(tune2fs -l /dev/sdb1 | grep 'Block count' | awk  '{ print $3 }')
echo "scale=5; ($a/$b)*100" | bc # this is the precentage of the reserved space
```

## Kill many processes at once (that much a pattern)
```
ps aux | grep -v grep | grep -i patternToMatch | awk '{print $2}' | xargs kill -9
```

## Problem: After deleting many files, the space is not freed and you need to delete the file descriptors
`find /proc/*/fd -ls 2> /dev/null | awk '/deleted/ {print $11}' | xargs -p -n 1 truncate -s 0`

## Add permanent bash alias

`vim ~/.bashrc` or `vim ~/.bash_aliases`
and add a line like this:
`alias fifa='ifconfig | grep ask'`
Then save the file and run:
`. ~/.bash_aliases` or `. ~/.bashrc`

- So, to change directory coloring for example run:
`echo "LS_COLORS=$LS_COLORS:'di=0;36:' ; export LS_COLORS" >> ~/.bash_aliases`

- Best values:
    - Cyan = 36
    - light purple = 95

- Table of color values:

Color|Value
:---:|:---:
Blue | 34
Green | 32
Light Green | 1;32
Cyan | 36
Red | 31
Purple | 35
Brown | 33
Yellow | 1;33
white | 1;37
Light Grey | 0;37
Black | 30
Dark Grey | 1;30
The first number is the style (1=bold), followed by a semicolon, and then the
actual number of the color

## Find number of CPUs and model
```
grep -c processor /proc/cpuinfo
lscpu
nproc
cat /proc/cpuinfo | grep name | tail -n1
```

## Dynamic linking

`ldd <executable_name>`
if you see *not found* for some library, put the <something>.so.x.x.x file in:
`/usr/local/lib`
`ln -s <something>.so.x.x.x <something>.so.x` (or whatever is needed)
and do: `ldconfig -v`
Then: `ldd <executable_name>` should be OK

## Change hostname

Stop MySQL if it is running: `service mysql stop`
```
old hostname = <old>
new hostname = <new>
```
In the next 2 files change `<old>` to `<new>`:
```
vim /etc/hosts
vim /etc/hostname
```
and run:
`hostname <new>`
Then check:
`hostname`

Restart MySQL (if needed): `service mysql start`

## Service tag

`dmidecode -t system`

## VIM: remove trailing whitespaces

```
:%s/\v\s+$//
:%s/\s\+$//e
```

## VIM: remove everything after first tab

`:%s/\t.*//`

## VIM: remove everything up to first comma

`:%s/^[^,]*,//`

## VIM: add 80-character colomn bar

```bash
vim /etc/vim/vimrc

# add line
set colorcolumn=80
```

## VIM: change comment color

Go to `/usr/share/vim/vim80/colors` and copy a file with a nice color scheme:
`cp ron.vim zobo.vim`
Then: `vim zobo.vim` and change lines:
`let g:colors_name = "zobo"`
`hi comment ctermfg=green guifg=green`
Then:
`vim /etc/vim/vimrc`
Add line somewhere: `color zobo`

## See cached files info in the pwd

`linux-fincore --pages=false --summarize --only-cached *`

## Clean cached memory (extremely useful :)

`sudo sysctl vm.drop_caches=3`

`sync && echo 3 | tee /proc/sys/vm/drop_caches`

## Build a specific filesystem on a disk partition

```
cat /etc/fstab
fdisk -l
cfdisk /dev/sdc
mkfs.ext4 /dev/sdc1
mount -a
df -h
```

