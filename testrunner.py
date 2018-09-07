# Copyright 2018 QuantRocket LLC - All Rights Reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import glob
import subprocess
import socket

class TestRunner:

    def __init__(self):
        self.env_name = os.environ.get("DOCKER_MACHINE_NAME", None) or "byon-dockerhub-{0}".format(socket.gethostname())
        self.src_dir = "/tmp/byon-dockerhub"

    def run(self):
        test_files = self._collect_test_files()
        if not test_files:
            return

        try:
            self._provision_node()
            for file in test_files:
                print("running tests in {0} on remote node".format(os.path.basename(file)))
                cmd = "bash /opt/byon-dockerhub/test.sh {0} {1}".format(
                    file, self.env_name)
                output = subprocess.check_output(
                    cmd.split(), stderr=subprocess.STDOUT,
                    universal_newlines=True)
                print(output)
        except subprocess.CalledProcessError as e:
            print(e.output)
            raise
        finally:
            self._destroy_node()

    def _collect_test_files(self):
        test_file_glob = "{0}/*._test.yml".format(self.src_dir)
        test_files = glob.glob(test_file_glob)
        if not test_files:
            print("No files found matching {0}".format(test_file_glob))
        return test_files

    def _provision_node(self):

        print("Creating remote node")
        cmd = ("docker-machine create --driver digitalocean "
               "--digitalocean-access-token={access_token} "
               "{driver_args} {env_name}".format(
                   access_token=os.environ["DIGITALOCEAN_ACCESS_TOKEN"],
                   driver_args=os.environ["DIGITALOCEAN_DRIVER_ARGS"],
                   env_name=self.env_name
               ))
        output = subprocess.check_output(
            cmd.split(), stderr=subprocess.STDOUT,
            universal_newlines=True)
        print(output)

    def _destroy_node(self):
        print("Destroying remote node")
        cmd = "docker-machine rm -y {0}".format(self.env_name)
        output = subprocess.check_output(
            cmd.split(), stderr=subprocess.STDOUT,
            universal_newlines=True)
        print(output)

if __name__ == "__main__":
    runner = TestRunner()
    runner.run()
