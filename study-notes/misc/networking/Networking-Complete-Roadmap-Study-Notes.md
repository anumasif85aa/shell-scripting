# Networking: Complete Roadmap Study Notes

> A beginner-to-practical guide covering networking fundamentals, models, addressing, subnetting, protocols, secure access, and troubleshooting.

## Learning Flow

```text
Networking basics
    ↓
Packets and data flow
    ↓
Network types and devices
    ↓
OSI and TCP/IP models
    ↓
IP addressing
    ↓
Subnetting and CIDR
    ↓
Ports and major protocols
    ↓
SSH and secure file transfer
    ↓
Systematic troubleshooting
```

---

## 1. What Is Networking?

Networking is the process of connecting two or more devices so they can communicate and share data, services, and resources.

### Why networks are needed

- Communication: email, chat, and video calls
- Sharing: files, printers, storage, and applications
- Access: websites, online banking, streaming, and cloud services
- Collaboration: multiple users working with shared information
- Centralized management: controlling users, systems, security, and backups

### Simple communication flow

```text
Sender → Data is divided into packets → Network devices forward packets → Receiver reassembles the data
```

**Key idea:** Networking is the invisible transport system behind the Internet and most modern technology.

---

## 2. Packets and Data Communication

A **packet** is a small formatted unit of data sent across a network.

### Simplified packet contents

| Part | Purpose |
|---|---|
| Source address | Identifies where the packet came from |
| Destination address | Identifies where the packet must go |
| Control information | Supports routing, ordering, and error detection |
| Payload | Contains the actual user or application data |

### Why data is divided into packets

- Large data becomes easier to transmit.
- Network links can be shared efficiently.
- Packets may be routed independently.
- Lost or corrupted data can often be retransmitted selectively.
- The receiver can reassemble the packets into the original data.

### Connection-oriented vs. connectionless communication

| Type | Characteristics | Main example |
|---|---|---|
| Connection-oriented | Establishes a logical connection and provides ordered, reliable delivery | TCP |
| Connectionless | Sends data without establishing a connection; lower overhead but no delivery guarantee | UDP |

**Remember:** TCP and UDP do not create physical dedicated paths. TCP establishes a logical session between endpoints.

---

## 3. Types of Networks

Networks can be classified by their geographical coverage and purpose.

| Type | Full name | Typical coverage | Example |
|---|---|---|---|
| PAN | Personal Area Network | Around one person, usually a few meters | Phone connected to earbuds by Bluetooth |
| LAN | Local Area Network | Room, home, office, or building | Home or office Ethernet/Wi-Fi network |
| CAN | Campus Area Network | Multiple buildings in one organization | University or corporate campus |
| MAN | Metropolitan Area Network | City or metropolitan region | City-wide service-provider network |
| WAN | Wide Area Network | Country, continent, or world | The Internet |

### Coverage flow

```text
PAN → LAN → CAN → MAN → WAN
smallest                         largest
```

These ranges are conceptual, not strict distance limits.

---

## 4. Common Network Devices

| Device | Main job | Typical OSI layer | Important point |
|---|---|---:|---|
| NIC | Connects a host to a network | 1 and 2 | Usually has a MAC address |
| Hub | Repeats incoming signals to every port | 1 | Obsolete in most modern networks |
| Switch | Forwards Ethernet frames within a LAN | 2 | Learns source MAC addresses in a MAC table |
| Router | Connects IP networks and selects routes | 3 | Uses destination IP and a routing table |
| Modem | Converts signals for an ISP access technology | 1/2 | Common with cable, DSL, and cellular connections |
| Wireless access point | Connects Wi-Fi clients to a wired LAN | 2 | Bridges wireless and Ethernet networks |
| Firewall | Allows or blocks traffic according to rules | 3–7 | Protects hosts and network boundaries |

### Traffic analogy

- NIC: lets a vehicle enter the road.
- Hub: repeats the message into every lane.
- Switch: directs local traffic toward the correct port.
- Router: chooses a path between different road systems.
- Modem: adapts your local connection to the ISP's access network.

---

## 5. OSI Model

The **Open Systems Interconnection (OSI) model** is a seven-layer reference model used to understand network communication.

| Layer | Name | Main responsibility | Examples | PDU |
|---:|---|---|---|---|
| 7 | Application | Provides network services to applications | HTTP, HTTPS, DNS, DHCP, SSH, SMTP | Data |
| 6 | Presentation | Formatting, encoding, encryption, and compression | TLS, JSON, JPEG, UTF-8 | Data |
| 5 | Session | Establishes and manages communication sessions | RPC, session controls | Data |
| 4 | Transport | End-to-end transport, ports, reliability, and flow control | TCP, UDP | TCP segment / UDP datagram |
| 3 | Network | Logical addressing and routing | IPv4, IPv6, ICMP | Packet |
| 2 | Data Link | Framing, MAC addressing, and local delivery | Ethernet, Wi-Fi, VLANs, ARP | Frame |
| 1 | Physical | Sends signals and raw bits through media | Copper, fiber, radio, hubs | Bits |

### Encapsulation and decapsulation

```text
Sending host:   Data → Segment/Datagram → Packet → Frame → Bits
Receiving host: Bits → Frame → Packet → Segment/Datagram → Data
```

Each lower layer adds control information called a **header**; Layer 2 usually also adds a trailer. The receiver removes this information in reverse order.

### Memory aid

From Layer 7 to Layer 1:

> **All People Seem To Need Data Processing**

---

## 6. TCP/IP Model

The TCP/IP model is the practical model used by Internet networks.

| TCP/IP layer | Related OSI layers | Purpose | Examples |
|---|---|---|---|
| Application | 7, 6, 5 | Application services and data representation | HTTP, DNS, DHCP, SSH, SMTP |
| Transport | 4 | End-to-end process communication | TCP, UDP |
| Internet | 3 | IP addressing and routing | IPv4, IPv6, ICMP |
| Network Access | 2, 1 | Local delivery and physical transmission | Ethernet, Wi-Fi, ARP |

### Opening a website: end-to-end flow

1. You enter a domain name in a browser.
2. DNS finds the server's IP address.
3. The client communicates with the server using TCP, or commonly QUIC over UDP for HTTP/3.
4. IP routes packets toward the destination.
5. Ethernet or Wi-Fi carries frames across each local link.
6. For HTTPS, TLS protects the application data.
7. The server returns the website content.

---

## 7. IP Addressing

An **IP address** is a logical address assigned to a network interface so it can send and receive IP packets.

### IPv4 vs. IPv6

| Feature | IPv4 | IPv6 |
|---|---|---|
| Size | 32 bits | 128 bits |
| Example | `192.168.1.10` | `2001:db8::10` |
| Notation | Four decimal octets | Hexadecimal groups |
| Address space | About 4.3 billion addresses | Extremely large |

### IPv4 structure

```text
192.168.1.10
 │   │  │  └─ fourth octet
 │   │  └──── third octet
 │   └─────── second octet
 └─────────── first octet
```

Each octet contains 8 bits and ranges from `0` to `255`.

### Private IPv4 ranges

| CIDR block | Address range |
|---|---|
| `10.0.0.0/8` | `10.0.0.0`–`10.255.255.255` |
| `172.16.0.0/12` | `172.16.0.0`–`172.31.255.255` |
| `192.168.0.0/16` | `192.168.0.0`–`192.168.255.255` |

Private addresses are used inside private networks and are not routed directly across the public Internet. NAT is commonly used when private hosts access the Internet.

### Useful special addresses

| Address/block | Meaning |
|---|---|
| `127.0.0.0/8` | IPv4 loopback; `127.0.0.1` is localhost |
| `0.0.0.0` | Unspecified address; meaning depends on context |
| `169.254.0.0/16` | IPv4 link-local addressing |
| `255.255.255.255` | Limited broadcast |
| `::1` | IPv6 loopback |

**Modern note:** Class A/B/C addressing is historical. Modern networks use classless CIDR prefixes.

---

## 8. Subnetting

Subnetting divides an IP network into smaller logical networks called **subnets**.

### Benefits

- Reduces Layer 2 broadcast domains
- Organizes departments, environments, or locations
- Helps apply routing and security policies
- Uses address space more deliberately
- Simplifies management and fault isolation

### Key terms

| Term | Meaning |
|---|---|
| Prefix length | Number of network bits, such as `/24` |
| Subnet mask | Dotted-decimal form of an IPv4 prefix |
| Network address | Identifies the subnet |
| Host range | Addresses normally assignable to hosts |
| Broadcast address | Reaches all IPv4 hosts in that subnet |

### Core formulas for traditional IPv4 subnets

```text
Host bits = 32 − prefix length
Total addresses = 2^(host bits)
Traditional usable hosts = 2^(host bits) − 2
```

The subtraction accounts for the network and broadcast addresses. Special cases exist: `/31` is commonly used on point-to-point links, and `/32` identifies one IPv4 address.

### Quick reference

| Prefix | Subnet mask | Block size | Total addresses | Traditional usable hosts |
|---:|---|---:|---:|---:|
| `/24` | `255.255.255.0` | 256 | 256 | 254 |
| `/25` | `255.255.255.128` | 128 | 128 | 126 |
| `/26` | `255.255.255.192` | 64 | 64 | 62 |
| `/27` | `255.255.255.224` | 32 | 32 | 30 |
| `/28` | `255.255.255.240` | 16 | 16 | 14 |
| `/29` | `255.255.255.248` | 8 | 8 | 6 |
| `/30` | `255.255.255.252` | 4 | 4 | 2 |

### Worked example: divide `/24` into four equal subnets

Given: `192.168.1.0/24`

1. Four subnets require 2 borrowed bits because `2² = 4`.
2. New prefix: `/24 + 2 = /26`.
3. `/26` mask: `255.255.255.192`.
4. Block size: `256 − 192 = 64`.

| Subnet | Network | First host | Last host | Broadcast |
|---:|---|---|---|---|
| 1 | `192.168.1.0/26` | `192.168.1.1` | `192.168.1.62` | `192.168.1.63` |
| 2 | `192.168.1.64/26` | `192.168.1.65` | `192.168.1.126` | `192.168.1.127` |
| 3 | `192.168.1.128/26` | `192.168.1.129` | `192.168.1.190` | `192.168.1.191` |
| 4 | `192.168.1.192/26` | `192.168.1.193` | `192.168.1.254` | `192.168.1.255` |

---

## 9. CIDR

**Classless Inter-Domain Routing (CIDR)** represents networks with a variable-length prefix, such as `192.168.10.0/24`.

### Why CIDR matters

- Replaced wasteful class-based allocation
- Allows networks of different sizes
- Supports route aggregation (summarization)
- Makes routing tables more efficient

### Reading a CIDR prefix

For `192.168.10.0/24`:

- First 24 bits: network portion
- Remaining 8 bits: host portion
- Mask: `255.255.255.0`
- Network: `192.168.10.0`
- Traditional host range: `192.168.10.1`–`192.168.10.254`
- Broadcast: `192.168.10.255`

**Subnetting flow:** required hosts/subnets → choose prefix → determine mask → find block size → list network boundaries → verify ranges.

---

## 10. Ports and Sockets

A **port** is a 16-bit logical identifier used to deliver transport-layer traffic to the correct application or process.

```text
IP address finds the host.
Port number identifies the application endpoint.
Protocol + source IP + source port + destination IP + destination port identifies a flow.
```

### Port ranges

| Range | Name | Typical use |
|---:|---|---|
| `0–1023` | System / well-known | Standard services |
| `1024–49151` | Registered | Vendor and application services |
| `49152–65535` | Dynamic / private | Usually temporary client ports |

### Common ports

| Port | Transport | Service | Purpose |
|---:|---|---|---|
| 20/21 | TCP | FTP | Data/control in traditional active FTP |
| 22 | TCP | SSH, SFTP, SCP | Secure remote access and file transfer |
| 23 | TCP | Telnet | Insecure remote terminal; avoid |
| 25 | TCP | SMTP | Email transfer |
| 53 | UDP/TCP | DNS | Name resolution and DNS operations |
| 67/68 | UDP | DHCPv4 | Server/client address configuration |
| 80 | TCP | HTTP | Unencrypted web traffic |
| 123 | UDP | NTP | Time synchronization |
| 443 | TCP and UDP | HTTPS | HTTP over TLS; UDP is used by HTTP/3/QUIC |
| 3306 | TCP | MySQL | Database service |
| 5432 | TCP | PostgreSQL | Database service |
| 6379 | TCP | Redis | In-memory data store |
| 8080 | TCP | HTTP alternate | Common development/proxy port |

### Inspect listening sockets on Linux

```bash
sudo ss -tulnp
sudo lsof -i -P -n
```

Common `ss` options: `-t` TCP, `-u` UDP, `-l` listening, `-n` numeric, `-p` process.

**Security rule:** expose only the ports that are required, restrict their source ranges where possible, and verify the application is actually listening.

---

## 11. DNS

The **Domain Name System (DNS)** is a distributed hierarchical system that maps names to data such as IP addresses.

### Resolution flow

```text
Application
   ↓
Local cache / hosts file
   ↓
Recursive resolver
   ↓
Root → TLD → Authoritative name server
   ↓
Answer returned and cached according to TTL
```

The recursive resolver may already have the answer cached, so it does not always query the hierarchy.

### Common DNS records

| Record | Purpose | Example concept |
|---|---|---|
| A | Name to IPv4 address | `example.com` → IPv4 |
| AAAA | Name to IPv6 address | `example.com` → IPv6 |
| CNAME | Alias to another name | `www` → canonical hostname |
| MX | Mail exchanger for a domain | Domain → mail server |
| NS | Authoritative name servers | Zone → DNS servers |
| TXT | Text-based policies or verification | SPF and ownership verification |
| PTR | Reverse lookup | IP address → hostname |

### Useful commands

```bash
dig example.com
dig example.com A
dig example.com MX
dig @8.8.8.8 example.com
dig -x 8.8.8.8
host example.com
nslookup example.com
```

**Troubleshooting order:** verify network reachability → inspect resolver configuration → query the expected DNS server → check record type/value → check TTL and caches.

---

## 12. HTTP and HTTPS

**HTTP** is an application-layer protocol used to request and deliver web resources. **HTTPS** is HTTP protected by TLS.

| Feature | HTTP | HTTPS |
|---|---|---|
| Default port | 80/TCP | 443/TCP; HTTP/3 uses 443/UDP |
| Encryption | No | Yes, using TLS |
| Server authentication | No built-in certificate validation | TLS certificate validates server identity |
| Integrity protection | No | Yes |
| URL | `http://` | `https://` |

### Common HTTP methods

| Method | Typical purpose |
|---|---|
| GET | Retrieve a resource |
| POST | Submit data or create/process a resource |
| PUT | Replace a resource |
| PATCH | Partially update a resource |
| DELETE | Remove a resource |
| HEAD | Retrieve headers without the response body |
| OPTIONS | Discover communication options/capabilities |

### Common HTTP status codes

| Code | Meaning |
|---:|---|
| 200 | OK |
| 201 | Created |
| 301 | Moved Permanently |
| 302 | Found / temporary redirect |
| 400 | Bad Request |
| 401 | Authentication required or invalid credentials |
| 403 | Authenticated or identified client is not permitted |
| 404 | Resource not found |
| 500 | Internal server error |
| 502 | Bad gateway |
| 503 | Service unavailable |
| 504 | Gateway timeout |

### Simplified TLS flow

1. Client and server negotiate TLS capabilities.
2. Server provides its certificate.
3. Client validates the certificate, hostname, chain, and validity period.
4. The parties establish shared session keys.
5. Encrypted and integrity-protected HTTP communication begins.

---

## 13. TCP and UDP

Both operate at the Transport layer.

| Feature | TCP | UDP |
|---|---|---|
| Connection style | Connection-oriented | Connectionless |
| Delivery guarantee | Provides acknowledgments and retransmission | No built-in guarantee |
| Ordering | Preserves byte-stream order | No built-in ordering |
| Flow/congestion control | Yes | Not built into UDP |
| Header size | Usually 20 bytes or more | 8 bytes |
| Typical use | HTTPS, SSH, email, file transfer, databases | DNS, VoIP, gaming, streaming, QUIC |

### TCP three-way handshake

```text
Client                         Server
  | -------- SYN ------------> |
  | <----- SYN + ACK ---------- |
  | -------- ACK ------------> |
  |     connection ready        |
```

### Choosing between them

- Choose TCP when reliable, ordered delivery is required.
- Choose UDP when low overhead, real-time delivery, multicast, or application-controlled reliability is more suitable.
- Protocols built on UDP, such as QUIC, can implement reliability and congestion control themselves.

**Important:** UDP still uses a checksum. “UDP is unreliable” means it does not itself acknowledge, retransmit, or reorder datagrams—not that it is unusable or careless.

---

## 14. SSH and SCP

**SSH (Secure Shell)** provides encrypted remote login and command execution. **SCP** securely copies files using SSH transport.

### Basic SSH use

```bash
ssh username@server_ip
ssh -p 2222 username@server_ip
ssh -i ~/.ssh/my_key username@server_ip
```

### Recommended key-based flow

```bash
# Create a modern Ed25519 key pair
ssh-keygen -t ed25519 -C "my-admin-key"

# Install the public key on the server
ssh-copy-id username@server_ip

# Connect
ssh username@server_ip
```

RSA may still be required for compatibility; when needed, use an adequately sized key such as `ssh-keygen -t rsa -b 4096`.

### SCP examples

```bash
# Local file to remote system
scp file.txt username@server_ip:/remote/path/

# Remote file to local system
scp username@server_ip:/remote/path/file.txt ./

# Copy a directory recursively
scp -r project/ username@server_ip:/remote/path/

# Use a specific key
scp -i ~/.ssh/my_key file.txt username@server_ip:/remote/path/
```

### SSH client configuration

```sshconfig
Host myserver
    HostName 10.0.1.10
    User ubuntu
    Port 22
    IdentityFile ~/.ssh/id_ed25519
```

Then connect with:

```bash
ssh myserver
```

### Security practices

- Verify the host-key fingerprint through a trusted channel before accepting it.
- Prefer SSH keys over passwords.
- Protect private keys with correct permissions and a passphrase.
- Disable direct root login when practical.
- Restrict port 22 at the firewall/security group to trusted source networks.
- Use SFTP or `rsync -e ssh` when their features are better suited than SCP.

---

## 15. Systematic Network Troubleshooting

Use a consistent workflow instead of trying random commands.

```text
Define the symptom
        ↓
Gather evidence
        ↓
Locate the failing layer
        ↓
Form and test one hypothesis
        ↓
Apply the safest fix
        ↓
Verify end to end
        ↓
Document cause, fix, and prevention
```

### Practical layered checklist

| Stage | Question | Useful checks |
|---|---|---|
| 1. Scope | One user, one host, one subnet, or everyone? | Compare affected and healthy systems |
| 2. Local link | Is the interface up? | `ip link`, `ip addr` |
| 3. Route | Is there a valid path/default gateway? | `ip route`, `ip route get <IP>` |
| 4. Reachability | Can packets reach the destination? | `ping`, `tracepath`, `traceroute` |
| 5. DNS | Does the name resolve correctly? | `dig`, `host`, `resolvectl` |
| 6. Port | Is the service listening and reachable? | `ss -tulnp`, `nc -vz`, `curl -v` |
| 7. Application | Is the service healthy? | `systemctl status`, `journalctl` |
| 8. Policy | Is traffic denied? | Host firewall, cloud security group/NACL, SELinux, proxy |
| 9. Change | What changed recently? | Deployment, route, DNS, certificate, firewall, package |

### Essential Linux commands

```bash
# Interface and addressing
ip -br addr
ip link

# Routing
ip route
ip route get 8.8.8.8

# DNS
resolvectl status
dig example.com

# Listening and active sockets
ss -tulnp
ss -tan

# Test an application endpoint
curl -v https://example.com
curl -I https://example.com

# Test a TCP port
nc -vz server.example.com 443

# Trace a path
tracepath server.example.com

# Packet capture
sudo tcpdump -nn -i any port 443

# Service and logs
systemctl status ssh
journalctl -u ssh --since "30 minutes ago"
```

### SSH troubleshooting flow

```text
Correct host/IP?
   ↓
Route and network reachable?
   ↓
TCP port 22 reachable?
   ↓
sshd running and listening?
   ↓
Correct username and key?
   ↓
Key/file permissions correct?
   ↓
Review client debug and server logs
```

Useful command:

```bash
ssh -vvv username@server_ip
```

### Before escalating

- Record the exact error and time.
- State the affected scope and business impact.
- Include tests already performed and their results.
- Note recent changes.
- Attach relevant logs without exposing passwords, tokens, or private keys.
- Explain the suspected failing layer and recommended next action.

---

## 16. End-to-End Example: Opening a Secure Website

1. The laptop gets an IP address, prefix, gateway, and DNS resolver—often through DHCP.
2. The browser asks DNS for the website's IP address.
3. The operating system checks the routing table.
4. If the destination is outside the local subnet, the packet is sent toward the default gateway.
5. ARP (IPv4) or Neighbor Discovery (IPv6) finds the next-hop link-layer address.
6. Switches forward local Ethernet frames; routers forward IP packets between networks.
7. The client connects using TCP with TLS, or QUIC over UDP for HTTP/3.
8. TLS authenticates the server and protects the traffic.
9. HTTP requests and responses carry the website content.
10. The receiving layers decapsulate the data and deliver it to the browser.

This one example connects the main topics:

```text
DHCP → IP/subnet → DNS → routing → ARP/ND → switching → TCP/UDP → TLS → HTTP
```

---

## 17. Quick Revision Sheet

| Question | Short answer |
|---|---|
| What connects devices within a LAN? | Usually a switch |
| What connects different IP networks? | Router |
| Which address is used for routing across networks? | IP address |
| Which address is mainly used for local frame delivery? | MAC address |
| Which layer uses ports? | Transport layer |
| Which protocol translates names to IP data? | DNS |
| What does `/24` mean? | The first 24 bits are the network prefix |
| TCP or UDP for SSH? | TCP |
| Default SSH port? | 22/TCP |
| Default HTTPS port? | 443; TCP for HTTP/1.1 and HTTP/2, UDP for HTTP/3 |
| What is encapsulation? | Adding layer-specific control information before transmission |
| First troubleshooting principle? | Define and reproduce the exact symptom |

---

## 18. Hands-On Practice Lab

Perform these on a Linux system you are authorized to test.

1. Display all IP addresses: `ip -br addr`
2. Find the default gateway: `ip route`
3. Show the route to `8.8.8.8`: `ip route get 8.8.8.8`
4. Resolve a domain: `dig example.com`
5. Display listening TCP/UDP sockets: `sudo ss -tulnp`
6. Test HTTPS headers: `curl -I https://example.com`
7. Test port 443: `nc -vz example.com 443`
8. Trace the path: `tracepath example.com`
9. Examine the SSH service: `systemctl status ssh` or `systemctl status sshd`
10. Explain the complete packet flow from your computer to the website.

### Practice questions

1. Why does a host need both an IP address and a subnet prefix?
2. When does a host send traffic to its default gateway?
3. What is the difference between a switch's MAC table and a router's routing table?
4. Why can DNS fail even when direct IP connectivity works?
5. How many traditional usable hosts are available in a `/27` subnet?
6. Why is a listening port not proof that a remote client can reach it?
7. What evidence would distinguish a DNS problem from an HTTPS problem?
8. Why should a private SSH key never be copied to a remote server?

---

## Final Takeaway

Strong networking knowledge is built in layers:

```text
Understand the path → Identify the layer → Inspect the evidence → Fix the root cause → Verify and document
```

Learn the concepts, practice the commands, and always connect each command to a specific troubleshooting question.
