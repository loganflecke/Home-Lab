# Install Elastic Search
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

sudo apt-get install apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update && sudo apt-get install elasticsearch

curl -so /etc/elasticsearch/elasticsearch.yml https://packages.wazuh.com/resources/4.9/elastic-stack/elasticsearch/8.x/elasticsearch.yml

sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/elastic-8.x.list

apt update
