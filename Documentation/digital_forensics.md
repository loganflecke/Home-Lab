# Forensics  

## Velociraptor  

Velociraptor collects and analyzes forensic artifacts from Windows and Linux systems. It allows access to disk and memory data directly from the machine. While Security Onion (172.18.1.10) shows activity logs and actions, Velociraptor (172.18.1.20) provides access to the data at rest. This makes it possible to detect anti-forensics techniques and extract detailed information from the file system.  

### Data Sources  

Focus is on forensic artifacts related to disk and memory:  
- **Memory Dumps**: Capture full memory images for malware analysis and process inspection.  
- **Master File Table (MFT)**: Review file metadata for timestamps, changes, and potential evidence of tampering.  
- **USN Journal**: Track file changes, deletions, and creations on NTFS volumes.  
- **Registry Hives**: Analyze Windows system settings, user activity, and malware persistence mechanisms.  
- **Other Disk Artifacts**: Prefetch files, browser history, event logs, and more for building timelines and finding traces of malicious activity.  

### Installation  

Velociraptor runs on a dedicated VM at 172.18.1.20. During installation, I made the following adjustments:  
1. Downloaded the Velociraptor binary and configured the server.  
2. Changed the GUI bind-address to the machine's IP (172.18.1.20) instead of the loopback address, ensuring I could access the web interface.  
3. Verified the web interface is accessible via HTTPS on port 8889.
4. Deployed agents to Windows and Linux machines using the preconfigured installer.

I opted not to set up automatic collection. Instead, I manually initiate artifact collection as needed to focus on specific endpoints or scenarios.  

### Usage Scenarios  

Velociraptor is used to perform in-depth forensic investigations:  
- **Disk Analysis**: Collect MFT and USN journal to examine file operations over time.  
- **Memory Analysis**: Capture and analyze memory dumps to inspect processes, open connections, and detect rootkits.  
- **Timeline Creation**: Combine file system metadata, event logs, and other artifacts to reconstruct activity leading up to and after an incident.  
- **Anti-Forensics Detection**: Identify attempts to hide or delete evidence, such as timestomping or log clearing.  

### Integration  

Velociraptor works alongside Security Onion to provide a complete view of incidents. Security Onion handles real-time activity logs and alerts, while Velociraptor gives access to the raw data on the machine itself. Together, they provide a more thorough approach to detection and response.  

### Challenges and Lessons  

Changing the GUI bind-address to the machine’s IP was an important step for ensuring remote access to the web interface. Deployment was straightforward, but learning to manually collect artifacts helped focus on priority data sources without overloading endpoints. The flexibility of Velociraptor makes it essential for forensic investigations, especially for handling artifacts like memory dumps, MFT, and USN journals.
