#!/bin/bash

gpu_ip=$(awsip sandbox-gpu-joep)
cpu_ip=$(awsip sandbox-cpu-joep)
comet_ip=$(awsip comet-dev)


config_fragments_folder='/home/jbarmentlo/.ssh/config_fragments/'
gpu_filename="${config_fragments_folder}sandbox_gpu_joep"
cpu_filename="${config_fragments_folder}sandbox_cpu_joep"
comet_filename="${config_fragments_folder}comet_dev"
base_config_filename="${config_fragments_folder}base_config"
config_tmp_filename="${config_fragments_folder}tmp_config"

rm -f $config_tmp_filename

if [ $gpu_ip != 'null' ]
then
    echo "Setting GPU dns to ${gpu_ip}"
    sed "s/HOST_PLACEHOLDER/${gpu_ip}/" $gpu_filename >> $config_tmp_filename
    echo -e "GPU sandbox has been added to hosts.\n"
else
    echo -e "GPU sandbox is off and has not been added to hosts\n"
fi


if [ $cpu_ip != 'null' ]
then
    echo "Setting CPU dns to ${cpu_ip}"
    sed "s/HOST_PLACEHOLDER/${cpu_ip}/" $cpu_filename >> $config_tmp_filename
    echo -e "CPU sandbox has been added to hosts\n"
else
    echo -e "CPU sandbox is off and has not been added to hosts\n"
fi


if [ $comet_ip != 'null' ]
then
    echo "Setting Comet dns to ${comet_ip}"
    sed "s/HOST_PLACEHOLDER/${comet_ip}/" $comet_filename >> $config_tmp_filename
    echo -e "Comet server has been added to hosts\n"
else
    echo -e "Comet serveris off and has not been added to hosts\n"
fi


echo -e "\nSaving .ssh/config file to .ssh/config.old\n"
cat /home/jbarmentlo/.ssh/config > /home/jbarmentlo/.ssh/config.old

if [[ (-e ~/.ssh/config && ! -e $base_config_filename) || (! "$(cat ~/.ssh/config)" =~ 'Auto Generated aws ssh config') ]];
then
    echo "FIRST TIME SETUP"
    echo "Your ~/.ssh/config file will be used as a base config for this script"
    echo "Your ~/.ssh/config file has been copied to ${base_config_filename}"
    cat /home/jbarmentlo/.ssh/config > $base_config_filename
fi

echo "Applying config changes to ~/.ssh/config"

cat $base_config_filename > /home/jbarmentlo/.ssh/config

echo -e "\n##################################################" >> /home/jbarmentlo/.ssh/config
echo    "#         Auto Generated aws ssh config          #"   >> /home/jbarmentlo/.ssh/config
echo -e "##################################################\n" >> /home/jbarmentlo/.ssh/config

cat $config_tmp_filename >> /home/jbarmentlo/.ssh/config

rm -f $config_tmp_filename
