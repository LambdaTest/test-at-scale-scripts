# Test-at-scale

Contains scripts to setup TAS.

- Laser <https://github.com/LambdaTest/laser>
- Photon <https://github.com/LambdaTest/photon>
- Neuron <https://github.com/LambdaTest/neuron>
- JS Runners <https://github.com/LambdaTest/test-at-scale-js>
- Test-at-Scale <https://github.com/LambdaTest/test-at-scale>
- Test-at-Scale-js-smart-select <https://github.com/LambdaTest/test-at-scale-js-smart-select>

## Dev Onboarding

### Local System Setup

#### Mac Users

- Install [Homebrew](https://brew.sh/).

```bash
/bin/bash -c "$(curl -fsSL <https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh>)"
```

- Install [Docker Desktop](https://www.docker.com/products/docker-desktop). Start the Docker Desktop Application before proceeding further.

- Add your machine’s [SSH keys on GitHub](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

- Create a new folder and paste mac_deployer.sh (refer Attachments) in that folder.

- Run the script using the command below. (You'll need to define credentials for various services and configurations of resources required by TestAtScale system)

```bash
bash mac_deployer.sh
```

**This script may ask for your root password in order to add entry in /etc/hosts.**


#### Linux(Ubuntu) Users:
- Note: Dollar sign($) represents command, it isn't included in command. You must know the password of root.
- First update system
``` bash
$ sudo apt-get update
```
- Requirements, you have to install recent version of GCC and glibc.
```bash
$ sudo apt-get install gcc gilbc
```
- It also need Git
``` bash
$ sudo apt-get install git-all
```
- Install docker by website https://docs.docker.com/desktop/install/ubuntu/

- Now install Homebrew
``` bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- Then set PATH for Homebrew by running.
```bash
$ echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/zuh/.profile
$ echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/zuh/.profile
$ eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
- Now install gcc by brew
```bash
$ brew install gcc
```
- Now git clone repository "LambdaTest/test-at-scale-scripts" by
```bash
$ git clone https://github.com/LambdaTest/test-at-scale-scripts.git
```
- Now check and go to newly generated directory name "test-at-scale-scripts"
```bash
$ cd test-at-scale-scripts/mac_setup
```
- And run script
``` bash
$ bash mac_deployer.sh 
```
- These steps are for linux ubuntu distribution, if you are user of any other linux distributions you may change some commands as per the distribution you have.
