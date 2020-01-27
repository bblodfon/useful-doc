# Useful Linux commands

## Add command path permanently

Go to `/etc/profile.d` and create a `test.sh` file.
Put inside something like this:
```
EXEC_HOME=/usr/bin/my-exetutable                                                         
export EXEC_HOME
```

Then, with `echo $JAVA_HOME` it's gonna be known to the whole system!

## vim remove trailing whitespaces

`:%s/\s\+$//e`

## bash terminal loops for counting

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

## export pdf to png/svg with awesome quality

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
pdftoppm -png -r 600 test_crop.pdf test.png

# SVG
pdf2svg test_crop.pdf test.svg
```

## extract one file from `tar.gz` file

`tar -xf example.tar.gz <file-name>`

## take specific characters from each line in a file

`cut -c 1-30 <file-name>`

## list tar.gz file contents with depth

Download perl script: [treeify](https://github.com/grawity/code/blob/master/misc/treeifyi)
and run: `tar -tf <file>.tar.gz | treeify -d 2`

## Do something on many files in a dir

*Something* can be: rendering notebooks to HTML or checking if the files are 
the same as other files for example
```bash
#!/bin/bash

files=`ls`
dir="/somewhere/over/the/rainbow"
rmd_files=`ls | grep Rmd`

for file in ${files}; do
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

## Add 80-character colomn bar in vim
```bash
vim /etc/vim/vimrc

# add line
set colorcolumn=80
```

## Change vim comment color
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
