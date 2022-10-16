
# Test At Scale Scripts

This repository contains multiple scripts to setup up Test At Scale (TAS).

- Laser https://github.com/LambdaTest/laser
- Photon https://github.com/LambdaTest/photon
- Neuron https://github.com/LambdaTest/neuron
- JS Runners https://github.com/LambdaTest/test-at-scale-js
- Test-at-Scale https://github.com/LambdaTest/test-at-scale
- Test-at-Scale-js-smart-select https://github.com/LambdaTest/test-at-scale-js-smart-select




## Installation for macOS using Homebrew

**1.** Install [Homebrew.](https://brew.sh/)

**2.** Type this command into your terminal:
```bash
  /bin/bash -c "$(curl -fsSL 
  <https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh>)"
```
**3.** Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and start the program before proceeding to the next steps.

**4.** Add your machines [SSH keys to your GitHub Account.](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

**5.** Create a new folder and paste the file **mac_deployer.sh** into it. Make sure you refer to the attachments in that folder.

**6.** Run the bash script below. You will need to define your credentials for various services and resources required by the TAS system.

```bash
bash mac_deployer.sh
```

*This script may ask for your root password in order to add an entry into /etc/hosts.*


## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`db-pass`

`azure-acc-name`

`azure-acc-key`

`github-client-id`

`github-client-secret`

`gitlab-client-id`

`bitbucket-client-id`

`bitbucket-client-secret`

`github-app-app-id`

`github-app-app-id`

`github-app-client-id`

`github-app-client-secret`

`github-app-private-key`
## How to obtain the Environment Variables

- **db_pass**:\
     This is the password for the database. You can use any password you want. This password will be used to connect to the database running in a MySql docker container locally from the application.
- **azure_acc_name:**   
    This is the name of the Azure account. You can find this in the Azure portal.
- **azure_acc_key:**\
    This is the key to the Azure account. You can find this in the Azure portal.
- **github_client_id:**   
    This is the client id of the GitHub application. You can find this in the GitHub application settings. View more at https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app
- **github_client_secret:**   
    This is the client secret of the GitHub application. You can find this in the GitHub application settings. View more at https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app
- **gitlab_client_id:**  
    This is the client id of the GitLab application. You can find this in the GitLab application settings. View more at https://docs.gitlab.com/ee/integration/oauth_provider.html
- **gitlab_client_secret:**   
    This is the client secret of the GitLab application. You can find this in the GitLab application settings. View more at https://docs.gitlab.com/ee/integration/oauth_provider.html
- **bitbucket_client_id:**   
    This is the client id of the Bitbucket application. You can find this in the Bitbucket application settings. View more at https://developer.atlassian.com/cloud/bitbucket/oauth-2/
- **bitbucket_client_secret:**   
    This is the client secret of the Bitbucket application. You can find this in the Bitbucket application settings. View more at https://developer.atlassian.com/cloud/bitbucket/oauth-2/
- **github_app_app_name:**  
    This is the name of the GitHub application. You can find this in the GitHub application settings. View more at https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app
- **github_app_app_id:** 
    This is the app id of the GitHub application. You can find this in the GitHub application settings. View more at https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app
- **github_app_client_id:**
    This is the client id of the GitHub application. You can find this in the GitHub application settings. View more at https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app
- **github_app_client_secret:**  
    This is the client secret of the GitHub application. You can find this in the GitHub application settings. View more at https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app
- **github_app_private_key:**\
    This is the private key of the GitHub application. You can find this in the GitHub application settings. View more at https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app
