# Apache Atlas Docker Setup

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)](https://www.docker.com/)

A production-ready Docker Compose setup for Apache Atlas with HBase, ZooKeeper, Solr, and Kafka - all properly configured and integrated.

## 🎯 Features

- ✅ **One-command startup** - Everything configured and ready to go
- ✅ **Proper service ordering** - ZooKeeper → HBase → Kafka → Atlas
- ✅ **Persistent data** - Volume mounting for data preservation
- ✅ **Health checks** - Automated container health monitoring
- ✅ **Sample data scripts** - Quick start with pre-built examples
- ✅ **Fixed ZooKeeper issues** - No more CONNECTIONLOSS errors

## 📋 Prerequisites

- Docker Desktop or Docker Engine (20.10+)
- Docker Compose (2.0+)
- At least 4GB RAM allocated to Docker
- 5GB free disk space

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/apache-atlas-docker.git
cd apache-atlas-docker
```

### 2. Start Apache Atlas

```bash
docker-compose up -d
```

> **Note:** First startup takes 2-3 minutes as all services initialize.

### 3. Access Atlas

Open your browser to: **http://localhost:21000**

**Default Credentials:**
- Username: `admin`
- Password: `admin`

### 4. Load Sample Data (Optional)

```bash
bash create-sample-data.sh
```

This creates sample databases and tables to explore Atlas features.

## 📁 Repository Structure

```
apache-atlas-docker/
├── docker-compose.yml          # Main Docker Compose configuration
├── atlas-startup.sh            # Service startup script
├── create-sample-data.sh       # Comprehensive sample data
├── add-sample-data.sh          # Simple sample data
├── README.md                   # This file
├── ATLAS_SETUP_GUIDE.md        # Detailed setup guide
├── QUICK_START_GUIDE.md        # Sample data guide
├── LICENSE                     # Apache 2.0 License
└── .gitignore                  # Git ignore rules
```

## 🔧 Configuration

### Docker Compose Services

The setup includes:

| Service | Port | Description |
|---------|------|-------------|
| Apache Atlas | 21000 | Main web UI and REST API |
| HBase Master | 16000 | HBase management interface |
| ZooKeeper | 2181 | Coordination service (embedded) |
| Solr | 9838 | Search backend (embedded) |
| Kafka | 9027 | Event streaming (embedded) |

### Environment Variables

You can customize the setup by modifying environment variables in `docker-compose.yml`:

```yaml
environment:
  - JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
  - ATLAS_SERVER_HEAP=-Xmx2048m  # Increase heap if needed
```

### Data Persistence

Data is stored in a named volume:

```bash
# View volume
docker volume ls | grep atlas

# Backup volume
docker run --rm -v default_atlas-data:/data -v $(pwd):/backup alpine tar czf /backup/atlas-backup.tar.gz /data

# Restore volume
docker run --rm -v default_atlas-data:/data -v $(pwd):/backup alpine tar xzf /backup/atlas-backup.tar.gz -C /
```

## 📖 Documentation

- **[ATLAS_SETUP_GUIDE.md](ATLAS_SETUP_GUIDE.md)** - Detailed setup instructions and troubleshooting
- **[QUICK_START_GUIDE.md](QUICK_START_GUIDE.md)** - Sample data creation and REST API usage
- **[Apache Atlas Documentation](https://atlas.apache.org/)** - Official documentation

## 🛠️ Common Operations

### View Logs

```bash
# All logs
docker-compose logs -f

# Atlas logs only
docker logs apache-atlas -f

# Last 100 lines
docker logs apache-atlas --tail 100
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart Atlas only
docker-compose restart apache-atlas
```

### Stop Services

```bash
# Stop (preserves data)
docker-compose down

# Stop and remove data
docker-compose down -v
```

### Check Service Health

```bash
docker-compose ps
docker ps --filter "name=apache-atlas"
```

## 🔍 Sample Data

### Quick Creation

```bash
# Comprehensive sample data (recommended)
bash create-sample-data.sh

# Simple sample data
bash add-sample-data.sh
```

### What's Created

**Databases:**
- `sales_db` - Customer and order data
- `analytics_db` - Analytics and reporting
- `sample_database` - Test database

**Tables:**
- `customers` - Customer master data
- `orders` - Order transactions
- `customer_analytics` - Aggregated analytics
- `sample_table` - Test table

### Verify Sample Data

```bash
# Via REST API
curl -u admin:admin http://localhost:21000/api/atlas/v2/search/basic?typeName=hive_table

# Via Web UI
# Navigate to Search tab → Select "hive_table" type
```

## 🐛 Troubleshooting

### Issue: Container Won't Start

**Solution:**
```bash
# Check logs
docker logs apache-atlas

# Ensure no port conflicts
netstat -an | grep 21000

# Restart with clean state
docker-compose down -v
docker-compose up -d
```

### Issue: ZooKeeper Connection Errors

**Solution:** This is fixed in our custom startup script. If you see these errors:
```
WARN - CONNECTIONLOSS for /hbase
```

Make sure you're using the included `atlas-startup.sh` as the entrypoint.

### Issue: Out of Memory

**Solution:** Increase Docker memory allocation:
1. Docker Desktop → Settings → Resources
2. Set Memory to at least 4GB
3. Restart Docker

### Issue: Slow Startup

**Normal behavior:** First startup takes 2-3 minutes
- HBase initialization: ~90 seconds
- Atlas initialization: ~30-60 seconds

**Check progress:**
```bash
docker logs apache-atlas -f
```

## 🔐 Security Considerations

⚠️ **This setup uses default credentials and is NOT production-ready without hardening.**

For production:
1. Change default passwords in Atlas configuration
2. Configure SSL/TLS
3. Set up proper authentication (LDAP/AD)
4. Enable Kerberos for Hadoop components
5. Configure network policies
6. Regular backup procedures

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apache Atlas community
- [sburn/apache-atlas](https://hub.docker.com/r/sburn/apache-atlas) Docker image
- All contributors

## 📧 Support

- **Issues:** [GitHub Issues](https://github.com/YOUR_USERNAME/apache-atlas-docker/issues)
- **Documentation:** [Apache Atlas Docs](https://atlas.apache.org/)
- **Community:** [Apache Atlas Mailing Lists](https://atlas.apache.org/community.html)

## 🗺️ Roadmap

- [ ] Add docker-compose profiles for different environments
- [ ] Include Jupyter notebook examples
- [ ] Add Prometheus/Grafana monitoring stack
- [ ] Create Kubernetes deployment manifests
- [ ] Add automated backup scripts
- [ ] Include data lineage visualization examples

---

**Star ⭐ this repository if it helped you!**
