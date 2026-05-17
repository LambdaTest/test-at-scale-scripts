# Test at Scale Scripts for TestMu AI (Formerly LambdaTest)

<p align="center">
  <a href="https://www.testmuai.com/"><img src="https://img.shields.io/badge/MADE%20BY%20TestMu%20AI-000000.svg?style=for-the-badge&labelColor=000" alt="Made by TestMu AI"></a>
  <a href="https://www.npmjs.com/package/@lambdatest/test-at-scale"><img src="https://img.shields.io/npm/v/@lambdatest/test-at-scale.svg?style=for-the-badge&labelColor=000000" alt="TAS version"></a>
  <a href="https://community.testmuai.com/"><img src="https://img.shields.io/badge/Join%20the%20community-blueviolet.svg?style=for-the-badge&labelColor=000000" alt="Community"></a>
</p>

## Getting Started

[TestMu AI](https://www.testmuai.com/) (Formerly LambdaTest) is the world's first full-stack AI Agentic Quality Engineering platform that empowers teams to test intelligently, smarter, and ship faster. Built for scale, it offers a full-stack testing cloud with 10K+ real devices and 3,000+ browsers. With AI-native test management, MCP servers, and agent-based automation, TestMu AI supports Selenium, Appium, Playwright, and all major frameworks.

With TestMu AI (Formerly LambdaTest), you can set up the Test At Scale (TAS) infrastructure using these scripts to run distributed, intelligent test execution at scale.

- [Sign up on TestMu AI](https://www.testmuai.com/register/) (Formerly LambdaTest).
- Follow the [TestMu AI documentation](https://www.testmuai.com/support/docs/) (Formerly LambdaTest) for the full setup walkthrough.

Contains scripts to setup TAS (Test At Scale) on TestMu AI (Formerly LambdaTest).

- Laser <https://github.com/LambdaTest/laser>
- Photon <https://github.com/LambdaTest/photon>
- Neuron <https://github.com/LambdaTest/neuron>
- JS Runners <https://github.com/LambdaTest/test-at-scale-js>
- Test-at-Scale <https://github.com/LambdaTest/test-at-scale>
- Test-at-Scale-js-smart-select <https://github.com/LambdaTest/test-at-scale-js-smart-select>

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running
- [Homebrew](https://brew.sh/) (for Mac users)
- SSH keys configured on GitHub
- Azure account credentials
- GitHub / GitLab / Bitbucket OAuth application credentials

### Setup

**Mac Users:**

Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install [Docker Desktop](https://www.docker.com/products/docker-desktop). Start the Docker Desktop Application before proceeding further.

Add your machine's [SSH keys on GitHub](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

Create a new folder and paste `mac_deployer.sh` in that folder.

Run the script using the command below. (You'll need to define credentials for various services and configurations of resources required by TestAtScale system)

```bash
bash mac_deployer.sh
```

**This script may ask for your root password in order to add entry in /etc/hosts.**

Set your credentials as environment variables (where applicable).

**macOS / Linux:**

```bash
export LT_USERNAME="YOUR_USERNAME"
export LT_ACCESS_KEY="YOUR_ACCESS_KEY"
```

**Windows:**

```bash
set LT_USERNAME="YOUR_USERNAME"
set LT_ACCESS_KEY="YOUR_ACCESS_KEY"
```

### Environment Variables

```bash
db_pass=db-pass
azure_acc_name=azure-acc-name
azure_acc_key=azure-acc-key
github_client_id=github-client-id
github_client_secret=github-client-secret
gitlab_client_id=gitlab-client-id
gitlab_client_secret=gitlab-client-secret
bitbucket_client_id=bitbucket-client-id
bitbucket_client_secret=bitbucket-client-secret
github_app_app_name=github-app-app-id
github_app_app_id=github-app-app-id
github_app_client_id=github-app-client-id
github_app_client_secret=github-app-client-secret
github_app_private_key=github-app-private-key
```

#### Obtaining the values for environment variables

| Variable    | Function | Find it here |
| :---------- | :-------- | :--------- |
| db_pass     | Password for the database will be used to connect to the database running in a mysql docker container locally from the application.| You can use any password you want.|
| azure_acc_name | Name of the Azure account.| Azure portal|
| azure_acc_key | Key of the Azure account.| Azure portal|
| github_client_id | Client ID of the GitHub application.| [GitHub application settings](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app)|
| github_client_secret | Client secret of the GitHub application.| [GitHub application settings](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app)|
| gitlab_client_id | Client ID of the GitLab application.| [GitLab application settings](https://docs.gitlab.com/ee/integration/oauth_provider.html)|
| gitlab_client_secret | Client secret of the GitLab application.| [GitLab application settings](https://docs.gitlab.com/ee/integration/oauth_provider.html)|
| bitbucket_client_id | Client ID of the Bitbucket application.| [Bitbucket application settings](https://developer.atlassian.com/cloud/bitbucket/oauth-2/)|
| bitbucket_client_secret | Client secret of the Bitbucket application.| [Bitbucket application settings](https://developer.atlassian.com/cloud/bitbucket/oauth-2/)|
| github_app_app_name | Name of the GitHub application.| [GitHub application settings](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app)|
| github_app_app_id | App ID of the GitHub application.| [GitHub application settings](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app)|
| github_app_client_id | Client ID of the GitHub application.| [GitHub application settings](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app)|
| github_app_client_secret | Client secret of the GitHub application.| [GitHub application settings](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app)|
| github_app_private_key | Private key of the GitHub application.| [GitHub application settings](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app)|

### Run tests

After running the setup script, the TAS infrastructure will be live. View results on your TestMu AI dashboard.

## Contributions

Contributions are welcome. Open an issue to discuss your idea before submitting a pull request. When reporting bugs, include your Node.js version, OS, and TAS version.

## TestMu AI (Formerly LambdaTest) Community

Connect with testers and developers in the [TestMu AI Community](https://community.testmuai.com/). Ask questions, share what you are building, and discuss best practices in test automation and DevOps.

## TestMu AI (Formerly LambdaTest) Certifications

Earn free [TestMu AI Certifications](https://www.testmuai.com/certifications/) for testers, developers, and QA engineers. Validate your skills in Selenium, Cypress, Playwright, Appium, Espresso and more. Industry-recognized, shareable on LinkedIn, and built by practitioners, not marketers.

## Learning Resources by TestMu AI (Formerly LambdaTest)

Learn modern testing through tutorials, guides, videos, and weekly updates:

* [TestMu AI Blog](https://www.testmuai.com/blog/)
* [TestMu AI Learning Hub](https://www.testmuai.com/learning-hub/)
* [TestMu AI on YouTube](https://www.youtube.com/@TestMuAI)
* [TestMu AI Newsletter](https://www.testmuai.com/newsletter/)

## LambdaTest is Now TestMu AI

On **January 12, 2026**, [LambdaTest evolved to TestMu AI](https://www.testmuai.com/lambdatest-is-now-testmuai/), the world's first fully autonomous **Agentic AI Quality Engineering Platform**.

Same team. Same infrastructure. Same customer accounts. All existing LambdaTest logins, scripts, capabilities, and integrations continue to work without change.

👉 Find the new home for [LambdaTest](https://www.testmuai.com).

### How LambdaTest Evolved into TestMu AI

In 2017, we launched LambdaTest with a simple mission: make testing fast, reliable, and accessible. As LambdaTest grew, we expanded into Test Intelligence, Visual Regression Testing, Accessibility Testing, API Testing, and Performance Testing, covering the full depth of the testing lifecycle.

As software development entered the AI era, testing had to evolve, too. We rebuilt the architecture to be AI-native from the ground up, with autonomous agents that **plan, author, execute, analyze, and optimize tests** while keeping humans in the loop. The platform integrates with your repos, CI, IDEs, and terminals, continuously learning from every code change and development signal.

That evolution earned a new name: **TestMu AI**, built for an AI-first future of quality engineering. TestMu is not a new name for us. It is the name of our annual community conference, which has brought together 100,000+ quality engineers to discuss how AI would reshape testing, long before that became an industry norm.

What started as a high-performance cloud testing platform has transformed into an AI-native, multi-agent system powering a connected, end-to-end quality layer. That evolution defined a new identity: LambdaTest evolved into TestMu AI, built for an AI-first future of quality engineering.

## Support

Got a question? Email [support@testmuai.com](mailto:support@testmuai.com) or chat with us 24x7 from our chat portal.
