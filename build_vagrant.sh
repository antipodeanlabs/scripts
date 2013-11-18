#!/bin/bash
set -e

TFLAG=false
usage="$(basename "$0") [-h] [-t <target>] -- program to build a specified vagrant image.

where:
    -h  show this help text
    -t  the target(required, one of elasticsearch, haproxy, java, postgresql, zabbix)"

while getopts :ht: option
do
    case "${option}"
    in
        h   ) echo "$usage";exit;;
        t   ) TFLAG=true;TARGET=${OPTARG};;
        \?  ) echo "invalid option: -$OPTARG" >&2;echo "$usage";exit 1;;
        :   ) echo "option -$OPTARG requires an argument." >&2;exit 1;;
        *   ) echo "unimplimented option: -$OPTARG" >&2; exit 1;;
esac
done

if ! $TFLAG
then
    echo "-t target must be supplied" >&2
    exit 1
fi

TEMPLATE=.$(date +%s).template.json
echo "creating template file $TEMPLATE"

sed 's/<image_name>/'$TARGET'/g' templates/vagrant.json > $TEMPLATE
echo "building vagrant image with template:"
cat $TEMPLATE

packer build $TEMPLATE
