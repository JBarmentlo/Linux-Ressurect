#!/bin/bash

gpu_ip=$(awsip sandbox-gpu-hind)


config_fragments_folder='/Users/h.dadoun/.ssh/config_fragments/'
gpu_filename="${config_fragments_folder}sandbox_gpu_hind"
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

echo -e "\nSaving .ssh/config file to .ssh/config.old\n"
cat /Users/h.dadoun/.ssh/config > /Users/h.dadoun/.ssh/config.old

if [[ (-e ~/.ssh/config && ! -e $base_config_filename) || (! "$(cat ~/.ssh/config)" =~ 'Auto Generated aws ssh config') ]];
then
    echo "FIRST TIME SETUP"
    echo "Your ~/.ssh/config file will be used as a base config for this script"
    echo "Your ~/.ssh/config file has been copied to ${base_config_filename}"
    cat /Users/h.dadoun/.ssh/config > $base_config_filename
fi

echo "Applying config changes to ~/.ssh/config"

cat $base_config_filename > /Users/h.dadoun/.ssh/config

echo -e "\n##################################################" >> /Users/h.dadoun/.ssh/config
echo    "#         Auto Generated aws ssh config          #"   >> /Users/h.dadoun/.ssh/config
echo -e "##################################################\n" >> /Users/h.dadoun/.ssh/config

cat $config_tmp_filename >> /Users/h.dadoun/.ssh/config

rm -f $config_tmp_filename
