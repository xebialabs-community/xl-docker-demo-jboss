unzip -q /tmp/downloads/mysql-connector-java-5.1.40.zip -d /tmp
count=0
/opt/wildfly/bin/standalone.sh -Djboss.bind.address=localhost -Djboss.bind.address.management=localhost &
while true
do
  if [ $count -le 90 ]; then

    wget --spider -q http://127.0.0.1:8080
    if [ $? -ne 0 ] ;then 
      echo "waiting $count"
      sleep 1
      count=$(( count+1 ))
    else 
      echo "Website is up"
      /opt/wildfly/bin/jboss-cli.sh -c "deploy /tmp/mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar"
      break
    fi
  else
    echo "Timeout exceeded...giving up waiting for website"
    exit 1
  fi
done
rm -rf /opt/wildfly/standalone/configuration/standalone_xml_history/current

