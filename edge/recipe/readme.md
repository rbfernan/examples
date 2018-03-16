# WIoTP Horizon Custom Workload Recipe

## Setting up your WIoTP organization

Create an organization (WIoTP US South only) and then use the Dashboard UI for the required setup:
1. In the Security menu, create an api key and token
2. Enable Edge as an experimental features 
3. In the Devices menu, in the Device Types tab, create a device type (make sure type is Gateway and Edge Capabilities toggle is enabled)
4. In the Browse tab, create a device with the gateway type defined in the previous step.

## Running the installation and configuration scripts

Copy the demo scripts to your edge node

1. Set the appropriate environment variables in the `Configuration section` of the `01-set_env_vars.sh` script with the organization, api key , device type and device info used to configure you WIoTP org.
2. Run the `01-set_env_vars.sh` to store the envirable variables configuration in a local file.
3. Run the `02-install_base_tools.sh`. This script will install:
- Docker
- Horizon and Horizon-wiotp debian packages
4. Run the `03-publish_cpu2witop.sh` script to build and publish the `cpu2wiopt` custom sample workload into your organization. Make sure you have a Docker Hub account setup for this step.
5. In the WIoTP Dashsboard, recreate your device in order to pick up the latest changes.
6. In the edge node, run the `04-run-agent-setup.sh` script to register your node with both WIoTP Edge Core IoT and cpu2wiotp workloads.

After step for you should be able to see the 6 docker containers running in your environment. (use `docker ps`)
Check the WIoTP Dashboard to see if CPU events are showing up for Device

Run the `05-simulate_cpu_load.sh`script to simulate an increase in the CPU load. Check the Device Recent Events again to see new messages coming up and the increase in cpu consumption.