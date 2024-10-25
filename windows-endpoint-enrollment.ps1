$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.10.4-windows-x86_64.zip -OutFile elastic-agent-8.10.4-windows-x86_64.zip
Expand-Archive .\elastic-agent-8.10.4-windows-x86_64.zip -DestinationPath .
cd elastic-agent-8.10.4-windows-x86_64
.\elastic-agent.exe install --url=https://172.18.1.10:8220 --enrollment-token=azQ5WHU1SUJLY2FhZ0RYTzFXU2c6bzBYc3h0Y0RTR3U1ckxKdXdmUENaZw==
