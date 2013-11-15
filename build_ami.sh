#!/bin/bash
set -e

TFLAG=false
usage="$(basename "$0") [-h] [-t <target> -e <except>] -- program to build a specified ami.

where:
    -h  show this help text
    -t  the target(required, one of elasticsearch, haproxy, java, postgresql, zabbix)
    -e  the builders to exclude, otherwise images will be built for all regions."

while getopts :hbt:e: option
do
    case "${option}"
    in
        h   ) echo "$usage";exit;;
        t   ) TFLAG=true;TARGET=${OPTARG};;
        e   ) EXCEPT=${OPTARG};;
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

sed 's/<image_name>/'$TARGET'/g' templates/ami.json > $TEMPLATE
echo "building ami image with template:"
cat $TEMPLATE
packer build -except=$EXCEPT $TEMPLATE
