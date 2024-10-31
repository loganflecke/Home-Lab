$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.10.4-windows-x86_64.zip -OutFile elastic-agent-8.10.4-windows-x86_64.zip
Expand-Archive .\elastic-agent-8.10.4-windows-x86_64.zip -DestinationPath .
cd elastic-agent-8.10.4-windows-x86_64
.\elastic-agent.exe install --url=https://172.18.1.10:8220 --enrollment-token=OG5BaDVKSUJ3a2pSSmlHRGUwekM6Rjl6dHgwTWlRUmk3cExrR2pRZWg2UQ==
