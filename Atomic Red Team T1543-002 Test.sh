echo "[Unit]" > /etc/systemd/system/art_test.service
echo "Description=Atomic Red Team Systemd Service" >> /etc/systemd/system/art_test.service
echo "" >> /etc/systemd/system/art_test.service
echo "[Service]" >> /etc/systemd/system/art_test.service
echo "Type=simple"
echo "ExecStart=#{execstart_action}" >> /etc/systemd/system/art_test.service
echo "ExecStartPre=#{execstartpre_action}" >> /etc/systemd/system/art_test.service
echo "ExecStartPost=#{execstartpost_action}" >> /etc/systemd/system/art_test.service
echo "ExecReload=#{execreload_action}" >> /etc/systemd/system/art_test.service
echo "ExecStop=#{execstop_action}" >> /etc/systemd/system/art_test.service
echo "ExecStopPost=#{execstoppost_action}" >> /etc/systemd/system/art_test.service
echo "" >> /etc/systemd/system/art_test.service
echo "[Install]" >> /etc/systemd/system/art_test.service
echo "WantedBy=default.target" >> /etc/systemd/system/art_test.service
systemctl daemon-reload
systemctl enable art_test.service
systemctl start art_test.service

