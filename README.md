# Installation Steps
1. [Download](https://github.com/semsaksoy/lssc/releases/download/LSSCv1/lssc-main.zip "Download") the content and unzip the package
2. Open the package content and move under “setup” directory.
3. Simply run “bash install.sh” with root privilege.
4. Make the relevant configuration for your environment. An example configuration will be installed which can be modified later on. 
5. Check the status of the lssc service at the end of the installation. 
PS: Ruby and libyaml are dependencies for this application but both package and installer script contains the dependencies and relevant installation commands.

# Configuration Arguments / Options

- **“sender**”: to define email sender address of the Qradar Server
- **“subject_stopped”**: to define email subject of the notification 
- **“subject_running”**: to define email subject when stopped log source starts again
-  **“control_frequency”**: to define the frequency of checking to the configurated log sources group’s online/offline states.


Under the “groups” list, N elements of log source group can be defined. To apply Log Source Stop 
Control Application, simply choose one of the log source group defined in the Qradar and open a list to 
make it applied. An example configuration is already installed and can be found in the package.

## Configuration parameters under the groups:

- **“stop_tolerance”**: to define log source stop tolerance (minutes of interruption of the log source state)
- **“notify_frequency”** : to define frequency of the  mail notification in minutes
- **“notify_clean”**: to define having notification when the state of the log source is turned as “running” (true/false)
- **“receiver**”: to define list of the users to get the log source stop notification emails.


# HA Log Source Stop Control Settings

LSSC Application support HA availability of log sources. It is possible to set HA Log source pairs. Thus, As log as both HA stops sending events, notification will be sent to the receivers. To set HA option, each failover peer should contain “ha:failoverpairname;” in log source description. 

 In example: logsourcename1 and logsourcename2 are failover log sources. To set HA option for LSSC application:
 
> Simply “ha:logsourcename2;” must contain in logsource1’s description and “ha:logsourcename1;” must contain in logsource2’s description.


