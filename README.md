# byon-dockerhub
byon-dockerhub provides the ability to run Docker Hub autotests on your own node instead of using the (slow) nodes provided by Docker Hub. byon-dockerhub (pronounced "beyond Docker Hub") lets you Bring Your Own Node (BYON) to go beyond Docker Hub.

# Quickstart

* rename your autotest file(s) so Docker Hub won't run them: `docker-compose.test.yml` -> `docker-compose._test.yml`
* copy `docker-compose.byon-dockerhub.test.yml` and `Dockerfile.byon-dockerhub.test` into the root of your repository. This is the Compose file and associated Dockerfile that Docker Hub will find and run.
* edit the `environment` section in `docker-compose.byon-dockerhub.test.yml` to provide your DigitalOcean access token, and optionally adjust the driver args as desired (for example, change the Droplet size or region).

When Docker Hub runs `docker-compose.byon-dockerhub.test.yml`, it will do the following:

* use Docker Machine to create a DigitalOcean droplet
* run all `*_test.yml` files on the remote droplet
* terminate the remote droplet
* exit according to the exit status of the `sut` container on the remote droplet. This is the exit status Docker Hub will see, with the automated build succeeding or failing accordingly.

Using byon-dockerhub allows you to utilize Docker Hub for build triggers, GitHub/Bitbucket integration, webhooks, etc., while farming out the actual testing to your own (superior) hardware.

## License

byon-dockerhub is distributed under the Apache 2.0 License. See the LICENSE file in the release for details.
