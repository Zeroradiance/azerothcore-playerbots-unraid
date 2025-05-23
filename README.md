# AzerothCore with Playerbots - Unraid Community App

Complete AzerothCore 3.3.5a World of Warcraft: Wrath of the Lich King private server with 400-500 intelligent AI Playerbots, optimized for Unraid.

## Features

- ✅ Full WotLK 3.3.5a server with all content
- ✅ 400-500 AI Playerbots populating the world
- ✅ Complete dungeon and raid support
- ✅ Cross-faction gameplay
- ✅ Built-in MySQL database
- ✅ Web administration via Adminer
- ✅ Optimized for Unraid with permission fixes
- ✅ Port conflict resolution (uses 3307 for MySQL)
- ✅ Named volumes for proper data persistence

## Installation

1. Install from Unraid Community Apps
2. Configure ports and paths as needed
3. Wait for database import (5-10 minutes)
4. Create admin account via console
5. Update WoW client realmlist.wtf
6. Enjoy your populated world!

## Quick Setup Commands

After installation, create your admin account:

Method 1: Direct console access

docker attach AzerothCore-Playerbots
account create admin password123
account set gmlevel admin 3 -1
Press Ctrl+P then Ctrl+Q to detach
Method 2: One-liner commands

docker exec -it AzerothCore-Playerbots bash -c "cd /azerothcore && echo 'account create admin password123' | timeout 30 ./env/dist/bin/worldserver"
docker exec -it AzerothCore-Playerbots bash -c "cd /azerothcore && echo 'account set gmlevel admin 3 -1' | timeout 30 ./env/dist/bin/worldserver"


### 4. Configure WoW Client

Edit your WoW 3.3.5a client realmlist:
- Location: `WoW_Client\Data\enUS\realmlist.wtf`
- Content: `set realmlist YOUR_UNRAID_IP`
- Example: `set realmlist 192.168.1.100`

### 5. Connect and Play

1. Start WoW 3.3.5a client
2. Login with: `admin` / `password123`
3. Create characters and enjoy 400-500 AI Playerbots!

## Database Management

Access Adminer at: `http://YOUR_UNRAID_IP:8056`
- Server: `azerothcore-database`
- Username: `root`
- Password: `acore123` (or your configured password)

## Troubleshooting

### Container Won't Start
- Check port conflicts (3307, 3724, 8085)
- Verify sufficient disk space (25GB+)
- Check Docker logs for errors

### Can't Connect to Server
- Verify realmlist.wtf points to correct IP
- Check firewall settings
- Ensure ports 3724 and 8085 are accessible

### No Playerbots Visible
- Wait for full database import completion
- Check WorldServer logs for Playerbots messages
- Verify all 4 databases created successfully

## Performance Tuning

### For 4GB RAM Systems
- Set Max Playerbots: 200-300
- Reduce MySQL memory usage

### For 8GB+ RAM Systems  
- Set Max Playerbots: 500-800
- Enable additional modules

## Support

- GitHub Issues: Create issue in repository
- Unraid Forums: Post in Docker Engine section
- AzerothCore Discord: Community support
