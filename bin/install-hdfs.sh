#!/bin/bash
host_num=3
ips=()
hosts=()

if [[ ! -e ./config ]]; then
  echo "ERR: config not exsits."
  echo 'INFO: config format is $ip $hostname'
  exit
fi

if [[ `whoami` != root ]]; then
  echo "ERR: root required"
  exit
fi

echo -e "input user to install: \c"
read username

echo "INFO: user is $username"

user_exist=1
id -u $username >/dev/null 2>&1
if (($? != 0)); then
  echo "ERR: user not exists."
  exit
fi

install_path=/opt/software
install_pkg=(
  jdk-8u211-linux-x64.tar.gz
  hadoop-3.1.3.tar.gz
  apache-zookeeper-3.5.7-bin.tar.gz
)

is_ok=1
for pkg in ${install_pkg[@]}
do
  if [[ ! -e $install_path/$pkg ]]; then
    echo $install_path/$pkg not found
    is_ok=0
  fi
done

if ((is_ok == 0)); then
  exit
fi

main_host=`ifconfig eth0 | grep cast | awk -F ' ' '{print $2}'`
echo "local host: $main_host"

i=0
while read line
do
  if ((i >= host_num)); then
    break
  fi
  na=($line)
  ips[$i]=${na[0]}
  hosts[$i]=${na[1]}
  ((++i))
done <config

if [[ $main_host != ${ips[0]} ]]; then
  echo ips[0] in config is not equal to $main_host
  exit
fi

hosts_config=`cat config`

for ((i=0; i < host_num; ++i))
do
  echo ${ips[$i]} ${hosts[$i]}
done

echo -e "ready to install?(Y/N): \c"
read ret
if [[ $ret != "Y" ]]; then
  exit 
fi

cat /dev/null > /etc/hosts
echo "$hosts_config" > /etc/hosts
echo ${hosts[$i]} > /etc/hostname

sed -i '/# === auto gen by install-hdfs.sh start ===/,/# === auto gen by install-hdfs.sh end ===/d' /etc/profile

echo \
'# === auto gen by install-hdfs.sh start ===
# JAVA
export JAVA_HOME=/usr/local/jdk/jdk1.8.0_211
export PATH=$JAVA_HOME/bin:$PATH
# ZOOKEEPER
export ZK_HOME=/usr/local/zookeeper/apache-zookeeper-3.5.7-bin
export PATH=$ZK_HOME/bin:$PATH
# HADOOP
export HADOOP_HOME=/usr/local/hadoop/hadoop-3.1.3
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
# === auto gen by install-hdfs.sh end ===' \
>> /etc/profile
source /etc/profile

if [[ ! -e /opt/software ]]; then mkdir /opt/software; fi
cd /opt/software

if [[ -e /usr/local/jdk ]]; then rm -rf /usr/local/jdk; fi
mkdir /usr/local/jdk
tar -zxvf jdk-8u211-linux-x64.tar.gz -C /usr/local/jdk

if [[ -e /usr/local/zookeeper ]]; then rm -rf /usr/local/zookeeper; fi
mkdir /usr/local/zookeeper
tar -zxvf apache-zookeeper-3.5.7-bin.tar.gz -C /usr/local/zookeeper

if [[ -e /data0/zkData ]]; then rm -rf /data0; fi
mkdir -p /data0/zkData
cd /data0/zkData/
touch myid
echo "1" > myid
cd $ZK_HOME/conf
cp zoo_sample.cfg zoo.cfg

sed -i "s/^dataDir.*/dataDir=\/data0\/zkData/g" zoo.cfg
for ((i=0; i < host_num; ++i)); do
((i == 0)) && thost=0.0.0.0 || thost=${hosts[$i]};
echo "server.$((i+1))=${hosts[$i]}:2888:3888" >> zoo.cfg; done

cd /opt/software
if [[ -e /usr/local/hadoop ]]; then rm -rf /usr/local/hadoop; fi
mkdir /usr/local/hadoop
tar -zxvf hadoop-3.1.3.tar.gz -C /usr/local/hadoop

cd $HADOOP_HOME/etc/hadoop
cat > hdfs-site.xml <<XML
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->
<configuration>

<!--???????????????-->
<property>
  <name>dfs.replication</name>
  <value>3</value>
</property>

<!--??????nameservice-->
<property>
  <name>dfs.nameservices</name>
  <value>mycluster</value>
</property>

<!--?????????NamenNode-->
<property>
  <name>dfs.ha.namenodes.mycluster</name>
  <value>nn1,nn2,nn3</value>
</property>
<property>
  <name>dfs.namenode.rpc-address.mycluster.nn1</name>
  <value>${hosts[0]}:8020</value>
</property>
<property>
  <name>dfs.namenode.rpc-address.mycluster.nn2</name>
  <value>${hosts[1]}:8020</value>
</property>
<property>
  <name>dfs.namenode.rpc-address.mycluster.nn3</name>
  <value>${hosts[2]}:8020</value>
</property>

<!--???NamneNode??????HTTP????????????-->
<property>
  <name>dfs.namenode.http-address.mycluster.nn1</name>
  <value>${hosts[0]}:9870</value>
</property>
<property>
  <name>dfs.namenode.http-address.mycluster.nn2</name>
  <value>${hosts[1]}:9870</value>
</property>
<property>
  <name>dfs.namenode.http-address.mycluster.nn3</name>
  <value>${hosts[2]}:9870</value>
</property>

<!--??????jn????????????-->
<property>
  <name>dfs.journalnode.edits.dir</name>
  <value>/data0/dfs/journal/data</value>
</property>

<!--??????jn???????????????????????????NameNode????????????-->
<property>
  <name>dfs.namenode.shared.edits.dir</name>
  <value>qjournal://${hosts[0]}:8485;${hosts[1]}:8485;${hosts[2]}:8485/mycluster</value>
</property>

<!--??????namenode???????????????????????????-->
<property>
  <name>dfs.namenode.name.dir</name>
  <value>/data0/hadoop/hdfs/name</value>
</property>

<!--??????datanode??????????????????--> 
<property>
  <name>dfs.datanode.data.dir</name>
  <value>/data0/hadoop/hdfs/data</value>
</property>

<!--??????HDFS???????????????Active NameNode?????????Java???-->
<property>
  <name>dfs.client.failover.proxy.provider.mycluster</name>
  <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
</property>

 <!-- ???????????????????????????????????????????????????????????????????????? -->
<property>
  <name>dfs.ha.fencing.methods</name>
  <value>
    sshfence
    shell(/bin/true)
  </value>
</property>

<!-- ???????????????????????????ssh???????????????-->
<property>
  <name>dfs.ha.fencing.ssh.private-key-files</name>
  <value>$HOME/.ssh/id_rsa</value>
</property>

<!-- ??????????????????-->
<property>
  <name>dfs.permissions.enable</name>
  <value>false</value>
</property>

<!--????????????????????????-->
 <property>
   <name>dfs.ha.automatic-failover.enabled</name>
   <value>true</value>
 </property>

<property>
    <name>dfs.client.use.datanode.hostname</name>
    <value>true</value>
    <description>only cofig in clients</description>
 </property>

</configuration>
XML

cat > core-site.xml <<XML
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!-- Put site-specific property overrides in this file. -->

<configuration>

<!--??????defaultFS-->
<property>
  <name>fs.defaultFS</name>
  <value>hdfs://mycluster</value>
</property>

<!--??????hadoop?????????????????????-->
<property>
  <name>hadoop.tmp.dir</name>
  <value>/data0/dfs/journal/tmp</value>
</property>

<!--??????zookeeper??????-->
<property>
  <name>ha.zookeeper.quorum</name>
  <value>${hosts[0]}:2181,${hosts[1]}:2181,${hosts[2]}:2181</value>        
</property>

</configuration>
XML

cat > yarn-site.xml <<XML
<?xml version="1.0"?>
<configuration>

<!-- Site specific YARN configuration properties -->

<!--yarn ???????????????-->
<property>
  <name>yarn.nodemanager.aux-services</name>
  <value>mapreduce_shuffle</value>
</property>

<property>
  <name>yarn.resourcemanager.ha.enabled</name>
  <value>true</value>
</property>

<property>
  <name>yarn.resourcemanager.cluster-id</name>
  <value>cluster1</value>
</property>

<property>
  <name>yarn.resourcemanager.ha.rm-ids</name>
  <value>rm1,rm2</value>
</property>

<property>
  <name>yarn.resourcemanager.hostname.rm1</name>
  <value>${hosts[0]}</value>
</property>

<property>
  <name>yarn.resourcemanager.hostname.rm2</name>
  <value>${hosts[2]}</value>
</property>

<property>
  <name>yarn.resourcemanager.webapp.address.rm1</name>
  <value>${hosts[0]}:8088</value>
</property>

<property>
  <name>yarn.resourcemanager.webapp.address.rm2</name>
  <value>${hosts[2]}:8088</value>
</property>

<property>
  <name>hadoop.zk.address</name>
  <value>${hosts[0]}:2181,${hosts[1]}:2181,${hosts[2]}:2181</value>        
</property>

 <!--??????????????????-->
<property>
  <name>yarn.resourcemanager.recovery.enabled</name>
  <value>true</value>
</property>

<!--??????resourcemanager????????????????????????zookeeper??????-->
<property>
  <name>yarn.resourcemanager.store.class</name>
  <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>
</property>

</configuration>
XML

cat /dev/null > workers
for ((i=0; i < host_num; ++i))
do
  echo ${hosts[$i]} >> workers
done

cd $HADOOP_HOME/sbin
sed -i "1a \\
HDFS_DATANODE_USER=$username\\
HADOOP_SECURE_DN_USER=hdfs\\
HDFS_NAMENODE_USER=$username\\
HDFS_SECONDARYNAMENODE_USER=$username\\
HDFS_JOURNALNODE_USER=$username\\
HDFS_ZKFC_USER=$username" start-dfs.sh stop-dfs.sh
sed -i "1a \\
YARN_RESOURCEMANAGER_USER=$username\\
HADOOP_SECURE_DN_USER=yarn\\
YARN_NODEMANAGER_USER=$username" start-yarn.sh stop-yarn.sh
echo 'export JAVA_HOME=/usr/local/jdk/jdk1.8.0_211' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

chown -R $username:$username /data0
chown -R $username:$username $JAVA_HOME
chown -R $username:$username $ZK_HOME
chown -R $username:$username $HADOOP_HOME

files=(
  /etc/hosts
  /etc/profile
  $JAVA_HOME
  $HADOOP_HOME
  $ZK_HOME
  /data0
)
echo "${hosts[@]}"
for ((i=1; i < host_num; ++i))
do
  host=${hosts[$i]}
  for file in ${files[@]}
    do          
      if [[ -e $file ]]; then      
        pdir=$(cd -P $(dirname $file); pwd)
        fname=$(basename $file) 
        ssh $host "mkdir -p $pdir"
        rsync -av $pdir/$fname $host:$pdir
        echo $pdir              
      else      
        echo $file does not exists! 
      fi      
    done        
done

for ((i=1; i < host_num; ++i))
do
host=${hosts[$i]}
ssh -T $host <<EOF
echo $(($i+1)) > /data0/zkData/myid 
echo $host > /etc/hostname
EOF
done

su - $username
