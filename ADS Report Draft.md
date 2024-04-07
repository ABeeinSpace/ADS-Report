RotaJakiro ADS Report
=========================
**Author:** *Aidan Border*

## Goal

Detect attempts to install the RotaJakiro backdoor on Linux hosts by looking for a droppped `systemd` services.

## Categorization

These attempts are categorized under [Persistence / Create or Modify System Process / Systemd service](https://attack.mitre.org/techniques/T1543/002).

## Strategy Abstract
Strategies for defending against this threat should go as follows:

* Use endpoint monitoring and protection tooling to monitor services or processes running on a Linux host.
* Look for specific service names or processes known to be used by RotaJakiro
  * sys-temd-agent.service
  * gvfsd-helper
  * systemd-daemon
* Fire an alert if any of these processes are found on the system.

## Technical Context

Most modern Linux systems use a project called `systemd` as their init system and services manager. `systemd` services are background programs that run to support different functionality. An example of a program that runs as a service is `sshd`, the OpenSSH Server daemon.

There are two directories that `systemd` will look for services in. 

1. System-wide services are located in /etc/systemd/system/services.
2. Services that run when a user logs in are located in ~/.config/systemd/user.

A `systemd` service can technically be used to automatically launch any software on the system. Threat actors can use this to auto-launch malicious software, such as starting a keylogger when a privileged user logs in to attempt to siphon administrator credentials to the system. It is important to note that a keylogger targeting X.Org is very easy to write. Installing a user-level service to log every keystroke to a file would be relatively easy given a way to run a shell script.

## Blind Spots and Assumptions

We assume the system uses systemd. Linux systems using other methods of init are not applicable for the ADS discussed here.

We assume RotaJakiro is running as root. If the backdoor is running as a normal user, it makes use of XDG Autostart (under a graphical environment) or .bashrc for users running without a desktop environment.

Unix systems, such as FreeBSD, do not use systemd. As such, the strategy discussed here is not applicable to those systems.

## False Positives

This alert may cause false positives for systems running the GNOME Desktop Environment if the backdoor is running without root privileges, as the backdoor masquerades as gvfsd, or the GNOME Virtual File System daemon.

## Validation

Validation can be performed by executing the provided shell script to generate a systemd service in the /etc/systemd/system directory.

```bash
echo "[Unit]" > /etc/systemd/system/sys-temd-agent.service
echo "Description=Atomic Red Team Systemd Service" >> /etc/systemd/system/sys-temd-agent.service
echo "" >> /etc/systemd/system/sys-temd-agent.service
echo "[Service]" >> /etc/systemd/system/sys-temd-agent.service
echo "Type=simple"
echo "ExecStart=#{execstart_action}" >> /etc/systemd/system/sys-temd-agent.service
echo "ExecStartPre=#{execstartpre_action}" >> /etc/systemd/system/sys-temd-agent.service
echo "ExecStartPost=#{execstartpost_action}" >> /etc/systemd/system/sys-temd-agent.service
echo "ExecReload=#{execreload_action}" >> /etc/systemd/system/sys-temd-agent.service
echo "ExecStop=#{execstop_action}" >> /etc/systemd/system/sys-temd-agent.service
echo "ExecStopPost=#{execstoppost_action}" >> /etc/systemd/system/sys-temd-agent.service
echo "" >> /etc/systemd/system/sys-temd-agent.service
echo "[Install]" >> /etc/systemd/system/sys-temd-agent.service
echo "WantedBy=default.target" >> /etc/systemd/system/sys-temd-agent.service
systemctl daemon-reload
systemctl enable sys-temd-agent.service
systemctl start sys-temd-agent.service
```

The detection should alert on the generated systemd service.

## Priority

Since this is a backdoor with a variety of features, any true positive alerts fired from this detection are set to high.

## Response

The following steps should be taken immediately upon a true positive alert:
  * Remove the system from the network
  * Disable the systemd service using `systemctl` to prevent it from running at boot, then stop the service. Alternatively, the system can simply be restarted. 
    * Depending on the security requirements of your environment, you may consider deleting the service file from the filesystem.
  * Kill the systemd-daemon binary if it is actively running.
    * Again, depending on your environment, the binary can be removed now as well
  * Escalate to a security incident after the immediate threat has been removed.

## Additional Resources

DELETE BEFORE SUBMISSION: [GitHub Markdown Reference ](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#links)


[^1]: Shell script originally published by [Atomic Red Team](https://atomicredteam.io/privilege-escalation/T1543.002/#atomic-test-1---create-systemd-service). I removed the templates and added the path to the systemd service location and name of the systemd service.

[^2]: [Arch boot process - Arch Wiki](https://wiki.archlinux.org/title/Arch_boot_process)

[^3]: [MITRE ATT&CK - Create or Modify System Process: Systemd Service](https://attack.mitre.org/techniques/T1543/002/)

[^4]: [RotaJakiro: A long live secret backdoor with 0 VT detection](https://blog.netlab.360.com/stealth_rotajakiro_backdoor_en/)

[^5]: [Backdoor.Linux.ROTAJAKIRO.A](https://www.trendmicro.com/vinfo/us/threat-encyclopedia/malware/backdoor.linux.rotajakiro.a/) 
