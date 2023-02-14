# create volume
docker volume create lk61

# create the docker image that use lk61 volume
docker run --detach --name lk61 --mount source=lk61,target=/root/workspace ubuntu:20.04 tail -f /dev/null

# start container
docker start lk61

# stop container
docker stop lk61

# attach bash to docker
docker exec -ti lk61 /bin/bash

# insall git
apt update && apt upgrade -y && apt install git -y


# url to linux https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-6.1.y
cd /root/workspace
git clone --depth 1 --branch linux-6.1.y https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git 

# https://phoenixnap.com/kb/build-linux-kernel
apt install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev biso -y
# additional convenience package
apt install htop vim curl -y

cd /root/workspace/linux

make defconfig
make menuconfig # check on Enable loadable module support/Module signature verification off

lscpu # to know number of cpus
time make -j6

apt install python3.9 -y #  8 10 when asked about region

# https://stackoverflow.com/questions/71034111/how-to-set-default-python3-to-python-3-9-instead-of-python-3-8-in-ubuntu-20-04-l
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
# update-alternatives --config python3

# Optional (did not help first time) install github credential manager: gh
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
type -p curl >/dev/null || apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& apt update \
&& apt install gh -y


# required only if you need to update the repository: put in /root/.ssh files from drive personal_ssh.zip
cd /root/workspace
git clone https://github.com/balcanuc/linuxkernelvscode.git
cp -R /root/workspace/linuxkernelvscode/.vscode /root/workspace/linux






