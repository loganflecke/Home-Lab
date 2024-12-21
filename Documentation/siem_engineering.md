# SIEM Engineering

## Log Sources

I’m focusing on Endpoint and Identity logs since most attacks now target these areas, and with security becoming less network-centric, this keeps the setup relevant and focused.

## Security Onion

Security Onion runs in standalone mode with a dummy monitoring adapter. This adapter is required for the system to remain operational, even though I’m not using it to monitor network traffic.

### Setup

The following are highlights of how i setup Security Onion, specific to my environment. 

	•	Download ISO and configure VM: Straightforward install.
	•	Network Configuration:
		•	Mapped Security Onion to a static DHCP mapping in pfSense.
		•	Copied the management adapter’s MAC address into pfSense to create the static mapping.
		•	Set Security Onion’s management adapter to the static IP assigned in pfSense.
	•	Disable Network Detection: No Zeek or PCAP.
	•	Elastic Agents: Installed on endpoints.
	•	Fixing Time Zone: The time zone had to be adjusted because agent logs were coming in over 3 hours ahead of Security Onion’s system time.

### Analysis

I use Kibana for log analysis. Main tasks include:
	•	Searching for key fields.
	•	Troubleshooting log ingestion issues. Key logs for debugging include:
	•	Logstash logs: /opt/so/log/logstash/logstash.log
	•	Elasticsearch logs: /opt/so/log/elasticsearch/securityonion.log