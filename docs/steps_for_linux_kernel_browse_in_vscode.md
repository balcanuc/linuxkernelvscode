## create volume
``` bash
docker volume create lk61
```
## create the docker image that use lk61 volume
```bash
docker run --detach --name lk61 --mount source=lk61,target=/root/workspace ubuntu:20.04 tail -f /dev/null
```

## start container
```bash
docker start lk61
```

## stop container
``` bash
docker stop lk61
```
## attach bash to docker
```bash
docker exec -ti lk61 /bin/bash
```

## install git
```bash
apt update && apt upgrade -y && apt install git -y
```

## fetch source code
the url to linux stable source https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-6.1.y   
Note that the only last commit is retrieved (`--depth 1`). 
```bash
cd /root/workspace
git clone --depth 1 --branch linux-6.1.y https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git 
```

## install pacakges that are required to build the kernel
instructions are copied from https://phoenixnap.com/kb/build-linux-kernel
```bash
apt install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev biso -y
```

## install additional convenience package
```bash
apt install htop vim curl unzip -y
```

## generate .config file
```bash
cd /root/workspace/linux
make defconfig
make menuconfig # check on Enable loadable module support/Module signature verification off
```

## build the kernel
adjust the number after `j` based on the output of the lscpu
```bash
lscpu # to know number of cpus
time make -j6
```

## install python
```bash
apt install python3.9 -y #  8 10 when asked about region
```
To make python 3.9 as default python3 run command below. This was copied from  
link: https://stackoverflow.com/questions/71034111/how-to-set-default-python3-to-python-3-9-instead-of-python-3-8-in-ubuntu-20-04-l
```bash
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
```
There might be required to also run command below
```bash
update-alternatives --config python3
```

## setup github
Optional (did not help first time) install github credential manager: `gh`  
link: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
```code lang bash
type -p curl >/dev/null || apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& apt update \
&& apt install gh -y
```

step below are required only if you need to update the repository: e.g. put in /root/.ssh files from drive personal_ssh.zip
```code
cd /root/workspace
git clone https://github.com/balcanuc/linuxkernelvscode.git
cp -R /root/workspace/linuxkernelvscode/.vscode /root/workspace/linux
```

## how to setup extraflags to keep .i files (files generated after processor).
for modules add
```code makefile
EXTRA_CFLAGS   += -DDEBUG -save-temps
```
In in the Makefile from the root of the kernel around line 560 modify the `KBUILD_CFLAGS` as below
```code makefile
KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
                   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
                   -Werror=implicit-function-declaration -Werror=implicit-int \
                   -Werror=return-type -Wno-format-security \
                   -std=gnu11 -save-temps
```


